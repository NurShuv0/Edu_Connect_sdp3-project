const mongoose = require("mongoose");

const TuitionApplicationSchema = new mongoose.Schema(
  {
    postId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "TuitionPost",
      required: true
    },

    teacherId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    status: {
      type: String,
      enum: ["pending_admin_review", "admin_approved", "admin_rejected", "student_approved", "student_rejected"],
      default: "pending_admin_review"
    },

    // Admin review fields
    adminReviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null
    },
    adminReviewDate: {
      type: Date,
      default: null
    },
    adminReviewNotes: {
      type: String,
      default: null
    },

    // Student (post creator) review fields
    studentReviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null
    },
    studentReviewDate: {
      type: Date,
      default: null
    },
    studentReviewNotes: {
      type: String,
      default: null
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("TuitionApplication", TuitionApplicationSchema);