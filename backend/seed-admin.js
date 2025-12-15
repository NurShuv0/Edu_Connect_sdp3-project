require("dotenv").config();
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const User = require("./models/User");

(async () => {
  try {
    if (!process.env.MONGO_URI) {
      console.error("❌ MONGO_URI not set in .env");
      process.exit(1);
    }

    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ Connected to MongoDB");

    const adminEmail = "admin@educonnect.com";
    const adminPassword = "Admin@12345";

    // Check if admin already exists
    let admin = await User.findOne({ email: adminEmail });
    if (admin) {
      console.log("✅ Admin account already exists:");
      console.log(`   Email: ${adminEmail}`);
      console.log(`   Password: ${adminPassword}`);
      console.log(`   Role: ${admin.role}`);
      console.log(`   Email Verified: ${admin.isEmailVerified}`);
    } else {
      // Create new admin
      const salt = await bcrypt.genSalt(10);
      const hash = await bcrypt.hash(adminPassword, salt);

      admin = await User.create({
        email: adminEmail,
        password: hash,
        name: "Admin User",
        phone: "+880123456789",
        role: "admin",
        isEmailVerified: true,
        isSuspended: false
      });

      console.log("✅ Admin account created successfully!");
      console.log(`   Email: ${adminEmail}`);
      console.log(`   Password: ${adminPassword}`);
      console.log(`   Role: ${admin.role}`);
      console.log(`   Email Verified: ${admin.isEmailVerified}`);
    }

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
})();
