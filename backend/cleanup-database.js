require("dotenv").config();
const mongoose = require("mongoose");
const User = require("./models/User");
const StudentProfile = require("./models/StudentProfile");
const TeacherProfile = require("./models/TeacherProfile");
const TuitionPost = require("./models/TuitionPost");
const ChatRoom = require("./models/ChatRoom");
const DemoSession = require("./models/DemoSession");

(async () => {
  try {
    if (!process.env.MONGO_URI) {
      console.error("❌ MONGO_URI not set in .env");
      process.exit(1);
    }

    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ Connected to MongoDB");

    // Get admin ID to keep
    const admin = await User.findOne({ email: "admin@educonnect.com" });
    const adminId = admin._id;

    // Find all non-admin user IDs
    const testUsers = await User.find({ email: { $ne: "admin@educonnect.com" } });
    const testUserIds = testUsers.map(u => u._id);

    console.log(`\n📊 Cleanup Statistics:`);
    console.log(`   Test users to clean: ${testUserIds.length}`);

    // Delete related data
    const studentProfiles = await StudentProfile.deleteMany({ userId: { $in: testUserIds } });
    console.log(`   ✅ Deleted ${studentProfiles.deletedCount} student profiles`);

    const teacherProfiles = await TeacherProfile.deleteMany({ userId: { $in: testUserIds } });
    console.log(`   ✅ Deleted ${teacherProfiles.deletedCount} teacher profiles`);

    const tuitions = await TuitionPost.deleteMany({ createdBy: { $in: testUserIds } });
    console.log(`   ✅ Deleted ${tuitions.deletedCount} tuition posts`);

    const chatRooms = await ChatRoom.deleteMany({ 
      $or: [
        { participants: { $in: testUserIds } },
        { createdBy: { $in: testUserIds } }
      ]
    });
    console.log(`   ✅ Deleted ${chatRooms.deletedCount} chat rooms`);

    const demos = await DemoSession.deleteMany({ 
      $or: [
        { studentId: { $in: testUserIds } },
        { teacherId: { $in: testUserIds } }
      ]
    });
    console.log(`   ✅ Deleted ${demos.deletedCount} demo sessions`);

    console.log(`\n✅ Complete cleanup done!`);
    console.log(`   Database is now clean with only admin account remaining`);

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
})();
