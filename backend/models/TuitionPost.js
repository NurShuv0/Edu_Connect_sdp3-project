const mongoose = require("mongoose");

const TuitionPostSchema = new mongoose.Schema(
  {
    studentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    title: { type: String, required: true },
    details: { type: String, default: "" },
    classLevel: { type: String, required: true },
    subjects: { type: [String], default: [] },

    salaryMin: { type: Number, default: 0 },
    salaryMax: { type: Number, default: 0 },

    location: {
      type: {
        type: String,
        enum: ["Point"],
        default: "Point"
      },
      coordinates: {
        type: [Number], // [lng, lat]
        default: [0, 0]
      },
      city: { type: String, default: "" },
      area: { type: String, default: "" }
    },

    isClosed: {
      type: Boolean,
      default: false
    },

    // Admin approval system
    isApproved: { type: Boolean, default: false },
    approvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null
    },
    approvalDate: { type: Date, default: null },
    rejectionReason: { type: String, default: null },
    status: {
      type: String,
      enum: ["pending", "approved", "rejected", "closed"],
      default: "pending"
    }
  },
  { timestamps: true }
);

TuitionPostSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("TuitionPost", TuitionPostSchema);