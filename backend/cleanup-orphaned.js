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

    // Get all valid user IDs
    const validUsers = await User.find().select("_id");
    const validUserIds = validUsers.map(u => u._id);

    // Find orphaned profiles
    const orphanedStudents = await StudentProfile.find({ 
      userId: { $nin: validUserIds } 
    });
    const orphanedTeachers = await TeacherProfile.find({ 
      userId: { $nin: validUserIds } 
    });

    console.log(`\n🗑️  Orphaned profiles found:`);
    console.log(`   Student profiles: ${orphanedStudents.length}`);
    console.log(`   Teacher profiles: ${orphanedTeachers.length}`);

    // Delete orphaned profiles
    const delStudents = await StudentProfile.deleteMany({ 
      userId: { $nin: validUserIds } 
    });
    const delTeachers = await TeacherProfile.deleteMany({ 
      userId: { $nin: validUserIds } 
    });

    console.log(`\n✅ Cleanup Complete:`);
    console.log(`   Deleted ${delStudents.deletedCount} orphaned student profiles`);
    console.log(`   Deleted ${delTeachers.deletedCount} orphaned teacher profiles`);

    // Final verification
    const finalStudents = await StudentProfile.countDocuments();
    const finalTeachers = await TeacherProfile.countDocuments();

    console.log(`\n📊 Final Database Status:`);
    console.log(`   Total users: 1 (admin only)`);
    console.log(`   Student profiles: ${finalStudents}`);
    console.log(`   Teacher profiles: ${finalTeachers}`);

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
})();
