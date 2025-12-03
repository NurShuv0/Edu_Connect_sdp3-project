// routes/adminRoutes.js
const express = require("express");
const router = express.Router();

const {
  getAdminStats,
  getAllUsers,
  toggleSuspendUser,
  approveTeacherProfile,
  approveTuition,
  approveApplication,
  getAllDemoSessions,
  updateDemoStatus,
  listUsers,
  getUserDetails,
  createAdmin,
  updateUserRole,
  suspendUser,
  activateUser,
  getDashboardStats,
  deleteUser,
  getPendingProfiles,
  approveUserProfile,
  rejectUserProfile,
  getPendingTuitionPosts,
  approveTuitionPost,
  rejectTuitionPost,
  getPendingNIDVerifications,
  verifyTeacherNID,
  rejectNIDVerification,
  banUser,
  unbanUser,
  createNotice,
  getNotices,
  deleteNotice,
  getParentControls,
  createParentControl,
  updateParentRestrictions
} = require("../controllers/adminController");

const { protect, requireRole } = require("../middleware/authMiddleware");
const { requireAdmin } = require("../middleware/adminMiddleware");

// All routes require authentication and admin role
router.use(protect, requireRole(["admin"]));

// --------------------------------------------------
// STATS & DASHBOARD
// --------------------------------------------------
router.get("/stats", getAdminStats); // Legacy endpoint
router.get("/dashboard/stats", getDashboardStats); // New enhanced endpoint

// --------------------------------------------------
// USER MANAGEMENT
// --------------------------------------------------
router.get("/users", listUsers); // List with pagination & filtering
router.get("/users/:userId", getUserDetails); // Get user details
router.post("/users/admin/create", createAdmin); // Create new admin
router.patch("/users/:userId/role", updateUserRole); // Update user role
router.patch("/users/:userId/suspend", suspendUser); // Suspend user
router.patch("/users/:userId/activate", activateUser); // Activate user
router.delete("/users/:userId", deleteUser); // Delete user (legacy toggle endpoint)
router.patch("/users/:userId/suspend-toggle", toggleSuspendUser); // Legacy toggle

// --------------------------------------------------
// PROFILE APPROVAL SYSTEM
// --------------------------------------------------
router.get("/profiles/pending", getPendingProfiles); // Get pending profiles
router.patch("/profiles/:userId/approve", approveUserProfile); // Approve profile
router.patch("/profiles/:userId/reject", rejectUserProfile); // Reject profile

// --------------------------------------------------
// TUITION POST APPROVAL SYSTEM
// --------------------------------------------------
router.get("/tuition-posts/pending", getPendingTuitionPosts); // Get pending posts
router.patch("/tuition-posts/:postId/approve", approveTuitionPost); // Approve post
router.patch("/tuition-posts/:postId/reject", rejectTuitionPost); // Reject post

// Legacy endpoints
router.patch("/teachers/:teacherId/approve", approveTeacherProfile);
router.patch("/tuition/:tuitionId/approve", approveTuition);
router.patch("/applications/:appId/approve", approveApplication);

// --------------------------------------------------
// NID VERIFICATION SYSTEM
// --------------------------------------------------
router.get("/nid/pending", getPendingNIDVerifications); // Get pending NIDs
router.patch("/nid/:nidId/verify", verifyTeacherNID); // Verify NID
router.patch("/nid/:nidId/reject", rejectNIDVerification); // Reject NID

// --------------------------------------------------
// BAN SYSTEM
// --------------------------------------------------
router.patch("/users/:userId/ban", banUser); // Ban user
router.patch("/users/:userId/unban", unbanUser); // Unban user

// --------------------------------------------------
// NOTICE SYSTEM
// --------------------------------------------------
router.post("/notices", createNotice); // Create notice
router.get("/notices", getNotices); // Get all notices
router.delete("/notices/:noticeId", deleteNotice); // Delete notice

// --------------------------------------------------
// PARENT CONTROL SYSTEM
// --------------------------------------------------
router.get("/parent-controls/:parentId", getParentControls); // Get controls
router.post("/parent-controls", createParentControl); // Create relationship
router.patch("/parent-controls/:controlId/restrictions", updateParentRestrictions); // Update restrictions

// --------------------------------------------------
// DEMO SESSIONS
// --------------------------------------------------
router.get("/demos", getAllDemoSessions);
router.patch("/demos/:sessionId", updateDemoStatus);

module.exports = router;
