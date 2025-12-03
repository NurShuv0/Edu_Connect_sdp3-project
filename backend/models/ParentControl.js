const mongoose = require("mongoose");

const ParentControlSchema = new mongoose.Schema(
  {
    parentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    childId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    // Relationship verification
    isVerified: { type: Boolean, default: false },
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null
    },
    verificationDate: { type: Date, default: null },

    // Restrictions
    restrictions: {
      canPostTuition: { type: Boolean, default: true },
      canApplyToTuition: { type: Boolean, default: true },
      canChat: { type: Boolean, default: true },
      canViewSearch: { type: Boolean, default: true },
      canViewProfile: { type: Boolean, default: true },
      maxDailyUsage: { type: Number, default: null }, // minutes
      blockedTeachers: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "User"
        }
      ],
      allowedTeachers: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "User"
        }
      ]
    },

    // Activity tracking
    activityLog: [
      {
        action: String,
        timestamp: { type: Date, default: Date.now },
        details: mongoose.Schema.Types.Mixed
      }
    ],

    isActive: { type: Boolean, default: true }
  },
  { timestamps: true }
);

// Compound index for parent-child relationship
ParentControlSchema.index({ parentId: 1, childId: 1 }, { unique: true });

module.exports = mongoose.model("ParentControl", ParentControlSchema);
