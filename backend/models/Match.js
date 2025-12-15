const mongoose = require("mongoose");

const matchSchema = new mongoose.Schema(
  {
    tuitionId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "TuitionPost",
      required: true
    },
    studentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    teacherId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    status: {
      type: String,
      enum: ["active", "ended"],
      default: "active"
    },
    isChatAllowed: {
      type: Boolean,
      default: true
    },
    isDemoAllowed: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Match", matchSchema);
