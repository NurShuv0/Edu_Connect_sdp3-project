// controllers/profileController.js
const StudentProfile = require("../models/StudentProfile");
const TeacherProfile = require("../models/TeacherProfile");
const User = require("../models/User");

/* --------------------------------------------------
   CREATE OR UPDATE STUDENT PROFILE
-------------------------------------------------- */
const createOrUpdateStudentProfile = async (req, res) => {
  try {
    const {
      fullName,
      classLevel,
      school,
      guardianName,
      guardianPhone,
      guardianNidNumber,
      location,
      parentControlEnabled
    } = req.body;

    const data = {
      userId: req.user._id,
      fullName,
      classLevel,
      school,
      guardianName,
      guardianPhone,
      guardianNidNumber,
      parentControlEnabled
    };

    if (location) {
      if (location.type === "Point" && location.coordinates) {
        // Test format: { type: "Point", coordinates: [lng, lat] }
        data.location = {
          type: "Point",
          coordinates: location.coordinates,
          city: location.city || "",
          area: location.area || ""
        };
      } else if (location.lat && location.lng) {
        // Alternative format: { lat, lng }
        data.location = {
          type: "Point",
          coordinates: [Number(location.lng), Number(location.lat)],
          city: location.city || "",
          area: location.area || ""
        };
      }
    }

    const profile = await StudentProfile.findOneAndUpdate(
      { userId: req.user._id },
      data,
      { new: true, upsert: true }
    );

    // Auto-approve student profile for testing/initial setup
    await User.findByIdAndUpdate(req.user._id, {
      isProfileApproved: true
    });

    res.json({ profile });
  } catch (err) {
    console.error("studentProfile error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

/* --------------------------------------------------
   CREATE OR UPDATE TEACHER PROFILE
-------------------------------------------------- */
const createOrUpdateTeacherProfile = async (req, res) => {
  try {
    const {
      fullName,
      subjects,
      expectedSalaryMin,
      expectedSalaryMax,
      expectedSalaryRange,
      university,
      department,
      jobTitle,
      experienceYears,
      location,
      serviceAreas,
      availableSlots,
      nidCardImageUrl
    } = req.body;

    // Handle both formats: expectedSalaryRange { min, max } or direct expectedSalaryMin/Max
    let salaryMin = expectedSalaryMin;
    let salaryMax = expectedSalaryMax;
    if (expectedSalaryRange) {
      salaryMin = expectedSalaryRange.min;
      salaryMax = expectedSalaryRange.max;
    }

    const data = {
      userId: req.user._id,
      fullName,
      subjects,
      expectedSalaryMin: salaryMin,
      expectedSalaryMax: salaryMax,
      university,
      department,
      jobTitle,
      experienceYears,
      serviceAreas,
      availableSlots,
      nidCardImageUrl
    };

    if (location) {
      if (location.type === "Point" && location.coordinates) {
        // Test format: { type: "Point", coordinates: [lng, lat] }
        data.location = {
          type: "Point",
          coordinates: location.coordinates
        };
      } else if (location.lat && location.lng) {
        // Alternative format: { lat, lng }
        data.location = {
          type: "Point",
          coordinates: [Number(location.lng), Number(location.lat)],
          city: location.city || "",
          area: location.area || ""
        };
      }
    }

    const profile = await TeacherProfile.findOneAndUpdate(
      { userId: req.user._id },
      data,
      { new: true, upsert: true }
    );

    // Auto-approve teacher profile for testing/initial setup
    await User.findByIdAndUpdate(req.user._id, {
      isProfileApproved: true
    });

    res.json({ profile });
  } catch (err) {
    console.error("teacherProfile error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

/* --------------------------------------------------
   GET MY PROFILE
-------------------------------------------------- */
const getMyProfile = async (req, res) => {
  try {
    let profile = null;

    if (req.user.role === "student") {
      profile = await StudentProfile.findOne({ userId: req.user._id });
    } else if (req.user.role === "teacher") {
      profile = await TeacherProfile.findOne({ userId: req.user._id });
    } else if (req.user.role === "admin") {
      // Admins don't have profiles
      return res.json({ profile: null });
    } else {
      return res.status(400).json({ message: "Invalid role" });
    }

    // Return profile (may be null if not created yet)
    res.json({ profile });
  } catch (err) {
    console.error("getMyProfile error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

/* --------------------------------------------------
   GET TOP TEACHERS BY RATING
   Fetches teachers with highest ratings
   Query: ?limit=5 (default)
-------------------------------------------------- */
const getTopTeachers = async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 5, 20);

    const teachers = await TeacherProfile.find({ isVerified: true })
      .sort({ ratingAverage: -1, ratingCount: -1 })
      .limit(limit)
      .populate("userId", "name email");

    return res.json({
      message: "Top teachers fetched",
      teachers: teachers.map(t => ({
        id: t._id,
        userId: t.userId?._id,
        name: t.userId?.name || "Unknown",
        email: t.userId?.email || "",
        subjects: t.subjects || [],
        ratingAverage: t.ratingAverage || 0,
        ratingCount: t.ratingCount || 0,
        university: t.university || "",
        jobTitle: t.jobTitle || "",
        location: t.location || {},
        about: t.about || ""
      }))
    });
  } catch (err) {
    console.error("getTopTeachers error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  createOrUpdateStudentProfile,
  createOrUpdateTeacherProfile,
  getMyProfile,
  getTopTeachers
};