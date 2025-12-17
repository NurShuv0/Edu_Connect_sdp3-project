// routes/profileRoutes.js
const express = require("express");
const router = express.Router();
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const {
  createOrUpdateTeacherProfile,
  createOrUpdateStudentProfile,
  getMyProfile,
  getTopTeachers,
  uploadTeacherCV
} = require("../controllers/profileController");

const { protect, requireRole } = require("../middleware/authMiddleware");

// Configure multer for CV uploads
const cvUploadDir = path.join(__dirname, '../public/uploads/cv');
if (!fs.existsSync(cvUploadDir)) {
  fs.mkdirSync(cvUploadDir, { recursive: true });
}

const cvUpload = multer({
  storage: multer.diskStorage({
    destination: (req, file, cb) => {
      const userDir = path.join(cvUploadDir, req.user._id.toString());
      if (!fs.existsSync(userDir)) {
        fs.mkdirSync(userDir, { recursive: true });
      }
      cb(null, userDir);
    },
    filename: (req, file, cb) => {
      const ext = path.extname(file.originalname);
      cb(null, `cv_${Date.now()}${ext}`);
    }
  }),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
  fileFilter: (req, file, cb) => {
    const allowedMimes = ['application/pdf', 'application/msword', 
                          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                          'image/jpeg', 'image/png'];
    if (allowedMimes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only PDF, DOC, DOCX, and images allowed.'));
    }
  }
});

/* --------------------------------------------------
   STUDENT — CREATE / UPDATE PROFILE
   Supports:
   - POST /api/profile/student
   - PUT  /api/profile/student
   - POST /api/profile/student/me   (legacy)
-------------------------------------------------- */
router.post(
  "/student",
  protect,
  requireRole(["student"]),
  createOrUpdateStudentProfile
);

router.put(
  "/student",
  protect,
  requireRole(["student"]),
  createOrUpdateStudentProfile
);

// Legacy alias (if frontend ever calls /student/me with POST)
router.post(
  "/student/me",
  protect,
  requireRole(["student"]),
  createOrUpdateStudentProfile
);

/* --------------------------------------------------
   TEACHER — CREATE / UPDATE PROFILE
   Supports:
   - POST /api/profile/teacher
   - PUT  /api/profile/teacher
   - POST /api/profile/teacher/me   (legacy)
-------------------------------------------------- */
router.post(
  "/teacher",
  protect,
  requireRole(["teacher"]),
  createOrUpdateTeacherProfile
);

router.put(
  "/teacher",
  protect,
  requireRole(["teacher"]),
  createOrUpdateTeacherProfile
);

// Legacy alias
router.post(
  "/teacher/me",
  protect,
  requireRole(["teacher"]),
  createOrUpdateTeacherProfile
);

/* --------------------------------------------------
   AUTH — GET MY PROFILE
   Supports:
   - GET /api/profile/me
   - GET /api/profile/student/me   (student only)
   - GET /api/profile/teacher/me   (teacher only)
-------------------------------------------------- */
router.get("/me", protect, getMyProfile);

router.get(
  "/student/me",
  protect,
  requireRole(["student"]),
  getMyProfile
);

router.get(
  "/teacher/me",
  protect,
  requireRole(["teacher"]),
  getMyProfile
);

// PUBLIC — GET TOP TEACHERS
router.get("/top-teachers", getTopTeachers);

/* --------------------------------------------------
   TEACHER — UPLOAD CV FILE
   POST /api/profile/teacher/upload-cv
   Requires: auth, teacher role, multipart file
-------------------------------------------------- */
router.post(
  "/teacher/upload-cv",
  protect,
  requireRole(["teacher"]),
  cvUpload.single("cv"),
  uploadTeacherCV
);

module.exports = router;