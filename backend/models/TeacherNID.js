const mongoose = require("mongoose");

const TeacherNIDSchema = new mongoose.Schema(
  {
    teacherId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    nidNumber: { type: String, required: true, unique: true },
    
    // Document storage paths/URLs
    frontImageUrl: { type: String, required: true },
    backImageUrl: { type: String, required: true },

    // Verification status
    isVerified: { type: Boolean, default: false },
    verificationStatus: {
      type: String,
      enum: ["pending", "verified", "rejected", "expired"],
      default: "pending"
    },

    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null
    },
    verificationDate: { type: Date, default: null },
    rejectionReason: { type: String, default: null },

    // NID expiration
    expiryDate: { type: Date, default: null },
    isExpired: { type: Boolean, default: false },

    // Document info
    fullName: { type: String, default: "" },
    dateOfBirth: { type: Date, default: null },
    issueDate: { type: Date, default: null }
  },
  { timestamps: true }
);

// Index for teacher lookup
TeacherNIDSchema.index({ teacherId: 1 });
TeacherNIDSchema.index({ nidNumber: 1 });

module.exports = mongoose.model("TeacherNID", TeacherNIDSchema);
