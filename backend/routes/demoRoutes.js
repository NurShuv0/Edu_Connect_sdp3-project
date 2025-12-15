const express = require("express");
const router = express.Router();

const {
  requestDemo,
  getAllDemoRequests,
  updateDemoStatus
} = require("../controllers/demoController");

const DemoSession = require("../models/DemoSession");
const { protect, requireRole, requireVerifiedEmail } = require("../middleware/authMiddleware");

/* --------------------------------------------------
   STUDENT — REQUEST DEMO
   POST /api/demo/matches/:matchId/request
-------------------------------------------------- */
router.post(
  "/matches/:matchId/request",
  protect,
  requireVerifiedEmail,
  requireRole(["student"]),
  requestDemo
);

/* --------------------------------------------------
   STUDENT/TEACHER — GET MY DEMO SESSIONS
   GET /api/demo/my
   (Used by dashboards)
-------------------------------------------------- */
router.get(
  "/my",
  protect,
  requireRole(["student", "teacher"]),
  async (req, res) => {
    try {
      const sessions = await DemoSession.find({
        $or: [
          { studentId: req.user._id },
          { teacherId: req.user._id }
        ]
      })
        .populate("studentId", "name email")
        .populate("teacherId", "name email");

      res.json({ sessions });
    } catch (err) {
      console.error("GET /demo/my error:", err);
      res.status(500).json({ message: "Server error" });
    }
  }
);

/* --------------------------------------------------
   ADMIN — VIEW ALL DEMOS (with optional status filter)
   GET /api/demo/admin/sessions?status=requested
-------------------------------------------------- */
router.get(
  "/admin/sessions",
  protect,
  requireRole(["admin"]),
  async (req, res) => {
    try {
      const { status } = req.query;
      const filter = status ? { status } : {};
      const sessions = await DemoSession.find(filter)
        .populate("studentId", "name email")
        .populate("teacherId", "name email")
        .sort({ createdAt: -1 });

      res.json({ demos: sessions });
    } catch (err) {
      console.error("GET /demo/admin/sessions error:", err);
      res.status(500).json({ message: "Server error" });
    }
  }
);

/* --------------------------------------------------
   ADMIN — UPDATE DEMO STATUS
   PATCH /api/demo/admin/sessions/:sessionId/status
-------------------------------------------------- */
router.patch(
  "/admin/sessions/:sessionId/status",
  protect,
  requireRole(["admin"]),
  updateDemoStatus
);

module.exports = router;
