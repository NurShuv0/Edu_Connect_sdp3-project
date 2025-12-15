const jwt = require("jsonwebtoken");
const User = require("../models/User");
const StudentProfile = require("../models/StudentProfile");
const ChatMessage = require("../models/ChatMessage");
const Notification = require("../models/Notification");
const { moderateText } = require("../middleware/contentModerationMiddleware");

function initChatSocket(io) {
  // Authenticate every socket connection using JWT
  io.use(async (socket, next) => {
    try {
      const token =
        socket.handshake.auth?.token || socket.handshake.query?.token;

      if (!token) {
        return next(new Error("No token provided"));
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await User.findById(decoded.id);

      if (!user) {
        return next(new Error("User not found"));
      }

      if (user.isSuspended) {
        return next(new Error("Account suspended"));
      }

      if (user.role === "student") {
        const profile = await StudentProfile.findOne({ userId: user._id });
        if (profile && profile.parentControlEnabled) {
          return next(new Error("Parent control enabled for this account"));
        }
      }

      socket.user = {
        _id: user._id.toString(),
        role: user.role,
        name: user.name,
        email: user.email
      };

      next();
    } catch (err) {
      console.error("Socket auth error:", err.message);
      next(new Error("Invalid token"));
    }
  });

  io.on("connection", (socket) => {
    console.log(`User ${socket.user.name} (${socket.user.role}) connected: ${socket.id}`);

    // ========================================
    // MATCH-BASED CHAT (Student-Teacher)
    // ========================================

    // Client joins a chat room (roomId should match your ChatRoom/_id)
    socket.on("joinRoom", ({ roomId }) => {
      if (!roomId) return;
      socket.join(roomId);
      socket.emit("joinedRoom", { roomId, userId: socket.user._id });
    });

    // Typing indicator
    socket.on("typing", ({ roomId, isTyping }) => {
      if (!roomId) return;
      socket.to(roomId).emit("typing", {
        roomId,
        userId: socket.user._id,
        name: socket.user.name,
        isTyping: !!isTyping
      });
    });

    // Send message via socket
    socket.on("sendMessage", async ({ roomId, text }) => {
      try {
        if (!roomId || !text) return;

        // Basic content moderation
        if (moderateText(text)) {
          socket.emit("messageError", {
            roomId,
            message: "Message contains inappropriate language"
          });
          return;
        }

        // Save to DB
        const msg = await ChatMessage.create({
          roomId,
          senderId: socket.user._id,
          text,
          status: "delivered"
        });

        // Emit to everyone in room (including sender)
        io.to(roomId).emit("newMessage", {
          _id: msg._id,
          roomId,
          senderId: msg.senderId,
          senderName: socket.user.name,
          text: msg.text,
          createdAt: msg.createdAt,
          status: msg.status
        });
      } catch (err) {
        console.error("sendMessage socket error:", err);
        socket.emit("messageError", {
          roomId,
          message: "Failed to send message"
        });
      }
    });

    // Mark messages as read
    socket.on("markRead", async ({ roomId }) => {
      try {
        if (!roomId) return;

        await ChatMessage.updateMany(
          {
            roomId,
            senderId: { $ne: socket.user._id },
            status: { $ne: "seen" }
          },
          { $set: { status: "seen" } }
        );

        io.to(roomId).emit("messagesRead", {
          roomId,
          userId: socket.user._id
        });
      } catch (err) {
        console.error("markRead socket error:", err);
      }
    });

    // ========================================
    // ADMIN ONE-WAY MESSAGING
    // ========================================

    // Admin joins user's notification channel (e.g., 'user_<userId>')
    socket.on("joinAdminChannel", ({ userId }) => {
      if (socket.user.role !== "admin") {
        socket.emit("error", { message: "Only admins can join admin channels" });
        return;
      }
      const channelId = `admin_${userId}`;
      socket.join(channelId);
      socket.emit("joinedAdminChannel", { channelId, userId });
    });

    // User joins their own notification channel to receive admin messages
    socket.on("joinUserNotifications", () => {
      const channelId = `admin_${socket.user._id}`;
      socket.join(channelId);
      socket.emit("joinedUserNotifications", { channelId: channelId });
    });

    // Admin sends direct message to user (one-way)
    socket.on("sendAdminMessage", async ({ recipientId, message, title }) => {
      try {
        if (socket.user.role !== "admin") {
          socket.emit("error", { message: "Only admins can send admin messages" });
          return;
        }

        if (!recipientId || !message) {
          socket.emit("error", { message: "Recipient and message required" });
          return;
        }

        // Verify recipient exists
        const recipient = await User.findById(recipientId);
        if (!recipient) {
          socket.emit("error", { message: "User not found" });
          return;
        }

        // Create notification in DB
        const notification = await Notification.create({
          userId: recipientId,
          title: title || "Message from Admin",
          message: message,
          isRead: false
        });

        // Send real-time message to user's channel
        const channelId = `admin_${recipientId}`;
        io.to(channelId).emit("newAdminMessage", {
          _id: notification._id,
          title: notification.title,
          message: notification.message,
          senderName: socket.user.name,
          createdAt: notification.createdAt,
          isRead: false
        });

        // Confirm to admin
        socket.emit("adminMessageSent", {
          recipientId,
          recipientEmail: recipient.email,
          messageId: notification._id
        });
      } catch (err) {
        console.error("sendAdminMessage error:", err);
        socket.emit("error", { message: "Failed to send message" });
      }
    });

    // User marks admin message as read
    socket.on("markAdminMessageRead", async ({ messageId }) => {
      try {
        await Notification.findByIdAndUpdate(messageId, { isRead: true });
        const channelId = `admin_${socket.user._id}`;
        io.to(channelId).emit("adminMessageRead", { messageId });
      } catch (err) {
        console.error("markAdminMessageRead error:", err);
      }
    });

    socket.on("disconnect", () => {
      console.log(`User ${socket.user.name} disconnected: ${socket.id}`);
    });
  });
}

module.exports = initChatSocket;
