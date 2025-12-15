require("dotenv").config();
const mongoose = require("mongoose");
const User = require("./models/User");

(async () => {
  try {
    if (!process.env.MONGO_URI) {
      console.error("❌ MONGO_URI not set in .env");
      process.exit(1);
    }

    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ Connected to MongoDB");

    // Keep only admin account
    const adminEmail = "admin@educonnect.com";

    // Delete all users except admin
    const result = await User.deleteMany({ email: { $ne: adminEmail } });

    console.log("✅ Deletion complete!");
    console.log(`   Deleted ${result.deletedCount} test accounts`);
    console.log(`   Kept admin account: ${adminEmail}`);

    // Verify admin still exists
    const admin = await User.findOne({ email: adminEmail });
    if (admin) {
      console.log(`   ✅ Admin verified: ${admin.name} (${admin.email})`);
    } else {
      console.log(`   ⚠️  Admin account not found!`);
    }

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
})();
