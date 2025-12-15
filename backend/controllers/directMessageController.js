const Notification = require("../models/Notification");
const User = require("../models/User");

/* --------------------------------------------------
   SEND DIRECT MESSAGE TO USER (ADMIN ONLY)
   Creates a notification/message for a specific user
-------------------------------------------------- */
const sendDirectMessage = async (req, res) => {
  try {
    const { recipientId, userId, message, title } = req.body;
    
    // Support both recipientId and userId for flexibility
    const targetUserId = recipientId || userId;

    if (!targetUserId || !message) {
      return res.status(400).json({
        message: "Recipient ID and message are required"
      });
    }

    // Verify recipient exists
    const recipient = await User.findById(targetUserId);
    if (!recipient) {
      return res.status(404).json({
        message: "User not found"
      });
    }

    // Create notification (acts as direct message)
    const notification = await Notification.create({
      userId: targetUserId,
      title: title || "Message from Admin",
      message: message,
      isRead: false
    });

    return res.status(201).json({
      message: "Message sent successfully",
      notification
    });
  } catch (err) {
    console.error("sendDirectMessage error:", err);
    return res.status(500).json({ message: "Server error", error: err.message });
  }
};

/* --------------------------------------------------
   GET MESSAGES FOR A USER
   Fetches all messages sent by admin to a user
-------------------------------------------------- */
const getUserMessages = async (req, res) => {
  try {
    const { userId } = req.params;

    const messages = await Notification.find({
      userId: userId
    })
      .sort({ createdAt: -1 });

    return res.json({
      message: "Messages fetched",
      count: messages.length,
      messages
    });
  } catch (err) {
    console.error("getUserMessages error:", err);
    return res.status(500).json({ message: "Server error" });
  }
};

/* --------------------------------------------------
   MARK MESSAGE AS READ
   Updates notification read status
-------------------------------------------------- */
const markMessageAsRead = async (req, res) => {
  try {
    const { messageId } = req.params;

    const notification = await Notification.findByIdAndUpdate(
      messageId,
      { isRead: true },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({ message: "Message not found" });
    }

    return res.json({
      message: "Message marked as read",
      notification
    });
  } catch (err) {
    console.error("markMessageAsRead error:", err);
    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  sendDirectMessage,
  getUserMessages,
  markMessageAsRead
};
