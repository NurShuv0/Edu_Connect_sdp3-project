require("dotenv").config();
const mongoose = require("mongoose");
const User = require("./models/User");
const StudentProfile = require("./models/StudentProfile");
const TeacherProfile = require("./models/TeacherProfile");

(async () => {
  try {
    if (!process.env.MONGO_URI) {
      console.error("❌ MONGO_URI not set in .env");
      process.exit(1);
    }

    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ Connected to MongoDB");

    // Count all records
    const totalUsers = await User.countDocuments();
    const students = await User.countDocuments({ role: "student" });
    const teachers = await User.countDocuments({ role: "teacher" });
    const admins = await User.countDocuments({ role: "admin" });

    const studentProfiles = await StudentProfile.countDocuments();
    const teacherProfiles = await TeacherProfile.countDocuments();

    console.log("\n📊 Database Status:");
    console.log(`   Total users: ${totalUsers}`);
    console.log(`   - Students: ${students}`);
    console.log(`   - Teachers: ${teachers}`);
    console.log(`   - Admins: ${admins}`);
    console.log(`   Student profiles: ${studentProfiles}`);
    console.log(`   Teacher profiles: ${teacherProfiles}`);

    // Show admin details
    const admin = await User.findOne({ role: "admin" });
    if (admin) {
      console.log(`\n✅ Admin Account Details:`);
      console.log(`   Name: ${admin.name}`);
      console.log(`   Email: ${admin.email}`);
      console.log(`   Role: ${admin.role}`);
      console.log(`   Email Verified: ${admin.isEmailVerified}`);
      console.log(`   Suspended: ${admin.isSuspended}`);
    }

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
})();
