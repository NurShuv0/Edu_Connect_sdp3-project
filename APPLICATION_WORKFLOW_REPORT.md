# 🎓 EduConnect - Application Workflow Report

**Generated:** December 8, 2025  
**Project:** EduConnect - Tuition Marketplace Platform  
**Status:** Multi-phase development with core features implemented

---

## 📌 Executive Summary

**EduConnect** is a comprehensive Flutter + Node.js + MongoDB tuition marketplace platform connecting students and teachers. The application handles user authentication, profile management, location-based tuition matching, real-time messaging, ratings, and administrative governance.

**Tech Stack:**
- **Frontend:** Flutter (Dart) - Cross-platform mobile/web
- **Backend:** Node.js + Express.js - RESTful API
- **Database:** MongoDB - NoSQL document storage
- **Real-time:** Socket.io - WebSocket messaging
- **Mapping:** OpenStreetMap + flutter_map - Location services

---

## 🔄 Application Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    USER JOURNEY FLOW                        │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐
│   LANDING    │
│   PAGE       │
└────┬─────────┘
     │
     ├─────────────┬──────────────┐
     │             │              │
     v             v              v
 ┌───────┐   ┌─────────┐   ┌──────────┐
 │ LOGIN │   │ REGISTER│   │   ADMIN  │
 └───┬───┘   └────┬────┘   │DASHBOARD │
     │            │        └──────────┘
     │     ROLE SELECT
     │     (Student/Teacher)
     │            │
     │            v
     │       ┌─────────┐
     │       │  OTP    │
     │       │VERIFY   │
     │       └────┬────┘
     │            │
     └────┬───────┘
          │
          v
     ┌─────────────────────────┐
     │   MAIN DASHBOARD        │
     │   ┌───────────────────┐ │
     │   │ Tab Navigation    │ │
     │   ├───────────────────┤ │
     │   │ 1. HOME TAB       │ │
     │   │ 2. SEARCH TAB     │ │
     │   │ 3. CHAT TAB       │ │
     │   │ 4. TUITION TAB    │ │
     │   │ 5. PROFILE TAB    │ │
     │   └───────────────────┘ │
     └─────────────────────────┘
```

---

## 🏗️ System Architecture

### **Three-Tier Architecture**

```
┌──────────────────────────────────────────────────────────────┐
│                   FRONTEND LAYER (Flutter)                   │
│  ┌─────────────┬──────────┬──────────┬────────┬────────────┐│
│  │ Auth Pages  │ Dashboard│ Search   │ Chat   │ Admin Page ││
│  └─────────────┴──────────┴──────────┴────────┴────────────┘│
│                   ↓ HTTP + WebSocket                         │
├──────────────────────────────────────────────────────────────┤
│                  API LAYER (Node.js/Express)                 │
│  ┌──────────┬─────────┬────────┬──────┬──────┬───────┐      │
│  │ Auth API │Profile  │Tuition │Chat  │Match │Admin  │      │
│  │ Routes   │ Routes  │ Routes │Routes│Routes│Routes │      │
│  └──────────┴─────────┴────────┴──────┴──────┴───────┘      │
│                   ↓ Database Queries                         │
├──────────────────────────────────────────────────────────────┤
│              DATABASE LAYER (MongoDB)                        │
│  ┌────────┬──────────┬──────────┬────────┬────────────────┐ │
│  │ Users  │Profiles  │ Tuitions │ Matches│ Communications │ │
│  └────────┴──────────┴──────────┴────────┴────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

---

## 📱 Frontend Structure (Flutter)

### **Directory Organization**

```
lib/
├── main.dart                          # App entry point with service initialization
│
├── src/
│   ├── app.dart                       # Root widget with GoRouter configuration
│   │
│   ├── config/
│   │   └── api_paths.dart            # API endpoint constants
│   │
│   ├── core/
│   │   ├── network/
│   │   │   └── api_client.dart       # HTTP client with JWT auth headers
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart     # Login/Register/OTP verification
│   │   │   ├── profile_service.dart  # User profile CRUD operations
│   │   │   ├── tuition_service.dart  # Tuition post management
│   │   │   ├── chat_service.dart     # Chat room & messaging
│   │   │   ├── profile_image_service.dart  # Local image caching
│   │   │   └── storage_service.dart  # SharedPreferences wrapper
│   │   │
│   │   ├── models/
│   │   │   └── user.dart             # User data model (non-password)
│   │   │
│   │   ├── widgets/
│   │   │   └── app_avatar.dart       # Reusable avatar with fade animation
│   │   │
│   │   └── utils/
│   │       └── snackbar_utils.dart   # UI notification helpers
│   │
│   └── ui/
│       ├── auth/
│       │   ├── login_page.dart       # Email + password login
│       │   ├── register_page.dart    # Name/email/password/role signup
│       │   └── otp_page.dart         # 6-digit OTP verification with 10-min timer
│       │
│       ├── dashboard/
│       │   ├── app_sidebar.dart      # Navigation drawer with menu items
│       │   ├── home_tab.dart         # Featured tuitions + notices + top teachers
│       │   ├── search_tab.dart       # Advanced filters + map display
│       │   ├── chat_tab.dart         # Active conversations list
│       │   ├── tuition_tab.dart      # User's tuition posts
│       │   └── profile_tab.dart      # Edit profile + NID upload (teachers)
│       │
│       ├── tuition/                  # Tuition detail & posting flows
│       ├── chat/                     # Chat detail views
│       ├── search/                   # Search result views
│       ├── components/               # Reusable UI components
│       ├── map/                      # Map widget implementations
│       └── admin/
│           └── admin_dashboard_page.dart  # 7-tab admin control panel
```

### **Key Frontend Features**

| Feature | Location | Status |
|---------|----------|--------|
| **Authentication** | `auth/` | ✅ Complete |
| **Profile Management** | `profile_tab.dart` | ✅ Complete |
| **Tuition Discovery** | `search_tab.dart` | ✅ Complete |
| **Location-Based Search** | `search_tab.dart` + `map/` | ✅ Complete |
| **Real-time Chat** | `chat_tab.dart` | ✅ Complete |
| **Admin Dashboard** | `admin/` | ✅ Complete |
| **Notice Board** | `home_tab.dart` | ✅ Complete |
| **Top Teachers Widget** | `home_tab.dart` | ✅ Complete |
| **NID Upload** | `profile_tab.dart` | ✅ Complete |

---

## 🔌 Backend Structure (Node.js)

### **API Architecture**

```
backend/
├── server.js                    # Express app setup, middleware, route mounting
│
├── config/
│   ├── db.js                   # MongoDB Mongoose connection
│   ├── logger.js               # Logging utility
│   └── email.js                # Nodemailer SMTP configuration
│
├── models/                      # Mongoose schemas
│   ├── User.js                 # Auth: email, password (bcrypt), role, verification
│   ├── StudentProfile.js       # Student: age, grade, preferences
│   ├── TeacherProfile.js       # Teacher: subjects, ratings, university
│   ├── TuitionPost.js          # Job posts with approval workflow
│   ├── Match.js                # Student-teacher pairings
│   ├── ChatRoom.js             # Conversation containers
│   ├── ChatMessage.js          # Individual messages (embedded in ChatRoom)
│   ├── DemoSession.js          # Demo class bookings
│   ├── Review.js               # Student ratings of teachers
│   ├── Notification.js         # Push notifications
│   ├── Notice.js               # Admin announcements
│   ├── TeacherNID.js           # NID document storage
│   ├── ParentControl.js        # Child account restrictions
│   └── Announcement.js         # System-wide alerts
│
├── controllers/                 # Business logic
│   ├── authController.js       # Login/register/OTP/token refresh
│   ├── profileController.js    # Profile CRUD + top teachers
│   ├── tuitionController.js    # Post CRUD + search + nearby
│   ├── chatController.js       # Chat room & message management
│   ├── matchController.js      # Match creation & status updates
│   ├── reviewController.js     # Rating & review submission
│   ├── notificationController.js # Notification CRUD
│   ├── announcementController.js # Notice creation
│   ├── demoController.js       # Demo session booking
│   ├── searchController.js     # Advanced search queries
│   └── adminController.js      # Admin governance operations
│
├── routes/                      # API endpoints
│   ├── authRoutes.js           # /api/auth/*
│   ├── profileRoutes.js        # /api/profile/*
│   ├── tuitionRoutes.js        # /api/tuition/*
│   ├── chatRoutes.js           # /api/chat/*
│   ├── matchRoutes.js          # /api/matches/*
│   ├── reviewRoutes.js         # /api/reviews/*
│   ├── notificationRoutes.js   # /api/notifications/*
│   ├── announcementRoutes.js   # /api/announcements/*
│   ├── demoRoutes.js           # /api/demo/*
│   ├── searchRoutes.js         # /api/search/*
│   └── adminRoutes.js          # /api/admin/*
│
├── middleware/                  # Request processing
│   ├── authMiddleware.js       # JWT verification
│   ├── adminMiddleware.js      # Admin role check
│   ├── errorMiddleware.js      # Global error handler
│   ├── validationMiddleware.js # Input validation
│   ├── rateLimitMiddleware.js  # Request throttling
│   ├── contentModerationMiddleware.js # Content filtering
│   ├── verificationMiddleware.js # Email verification check
│   └── parentControlMiddleware.js # Child account restrictions
│
├── sockets/                     # WebSocket handlers
│   └── chatSocket.js           # Real-time messaging via Socket.io
│
├── utils/                       # Helper functions
│   ├── emailUtils.js           # OTP sending
│   ├── jwtUtils.js             # Token generation/verification
│   └── hashUtils.js            # Password hashing
│
├── docs/
│   └── openapi.yaml            # API specification (Swagger)
│
└── tests/
    ├── test-health.js          # Server health check
    └── test-simple.js          # Basic API tests
```

---

## 📊 Database Models (MongoDB)

### **1. User Model (Core Authentication)**
```javascript
{
  _id: ObjectId,
  email: String (unique, lowercased),
  password: String (bcrypt hashed),
  name: String,
  phone: String,
  role: Enum ['student', 'teacher'],
  
  // Verification & Status
  emailVerified: Boolean,
  isSuspended: Boolean,
  suspensionReason: String,
  
  // Admin Approval System
  isApproved: Boolean,
  approvalStatus: Enum ['pending', 'approved', 'rejected'],
  approvalReason: String,
  
  createdAt: Date,
  updatedAt: Date
}
```

### **2. TeacherProfile Model**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  
  // Professional Info
  university: String,
  department: String,
  jobTitle: String,
  
  // Teaching Details
  subjects: [String],
  classLevels: [String],
  salaryExpectation: Number,
  availability: String,
  bio: String,
  
  // Location (GeoJSON for $nearSphere queries)
  location: {
    type: 'Point',
    coordinates: [longitude, latitude]
  },
  city: String,
  
  // Rating System
  ratingAverage: Number,
  ratingCount: Number,
  
  // Verification
  isVerified: Boolean,
  nidCardImageUrl: String,
  
  createdAt: Date,
  updatedAt: Date
}
```

### **3. StudentProfile Model**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  
  age: Number,
  grade: String,
  subjects: [String],
  learningPreferences: String,
  
  location: {
    type: 'Point',
    coordinates: [longitude, latitude]
  },
  city: String,
  
  createdAt: Date,
  updatedAt: Date
}
```

### **4. TuitionPost Model**
```javascript
{
  _id: ObjectId,
  creatorId: ObjectId (ref: User),
  
  // Job Details
  subjects: [String],
  classLevel: String,
  description: String,
  salaryRange: Number,
  deadline: Date,
  
  // Location
  location: {
    type: 'Point',
    coordinates: [longitude, latitude]
  },
  city: String,
  
  // Status Workflow
  status: Enum ['active', 'inactive', 'closed'],
  isApproved: Boolean,
  approvalStatus: Enum ['pending', 'approved', 'rejected'],
  
  // Applications
  applicants: [ObjectId],
  
  createdAt: Date,
  updatedAt: Date
}
```

### **5. Match Model**
```javascript
{
  _id: ObjectId,
  studentId: ObjectId (ref: User),
  teacherId: ObjectId (ref: User),
  tuitionPostId: ObjectId (ref: TuitionPost),
  
  // Workflow
  status: Enum ['pending', 'accepted', 'rejected', 'completed'],
  
  // Feedback
  rating: Number,
  feedback: String,
  
  createdAt: Date,
  updatedAt: Date
}
```

### **6. ChatRoom & ChatMessage Models**
```javascript
ChatRoom {
  _id: ObjectId,
  participants: [studentId, teacherId],
  messages: [ChatMessage] (embedded array),
  createdAt: Date,
  updatedAt: Date
}

ChatMessage {
  _id: ObjectId,
  senderId: ObjectId,
  message: String,
  timestamp: Date
}
```

### **7. Additional Models**
- **Notice**: Admin announcements with priority & type
- **Notification**: User notifications (match alerts, reviews, etc.)
- **Review**: Teacher ratings + student feedback
- **TeacherNID**: NID verification documents
- **ParentControl**: Child account restrictions
- **DemoSession**: Demo class bookings

---

## 🔐 Authentication Flow

### **User Registration Flow**

```
┌──────────────────┐
│  1. User enters: │
│  - Name          │
│  - Email         │
│  - Password      │
│  - Role          │
└────────┬─────────┘
         │
         v
┌──────────────────────────────────────┐
│ 2. Frontend validates:               │
│    - Email format                    │
│    - Password length                 │
│    - Password confirmation match     │
│    - Role selected                   │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 3. POST /api/auth/register           │
│    Send: { name, email, password,    │
│            role }                    │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 4. Backend validates & creates User  │
│    - Hash password (bcrypt)          │
│    - Create User document            │
│    - Generate OTP code               │
│    - Send OTP via email              │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 5. Redirect to OTP Verification Page │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 6. User enters 6-digit OTP code      │
│    (10-minute countdown timer)       │
│    - Can resend after timeout        │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 7. POST /api/auth/verify-otp         │
│    Verify OTP against stored code    │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 8. Backend response:                 │
│    - Mark emailVerified = true       │
│    - Generate JWT token              │
│    - Return token (7-day expiry)     │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 9. Frontend stores token securely    │
│    (flutter_secure_storage)          │
│    - Redirect to Dashboard           │
│    - Create profile (Student/Teacher)│
└──────────────────────────────────────┘
```

### **Login Flow**

```
┌──────────────────┐
│  1. User enters: │
│  - Email         │
│  - Password      │
└────────┬─────────┘
         │
         v
┌──────────────────────────────────────┐
│ 2. Frontend validates input          │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 3. POST /api/auth/login              │
│    Send: { email, password }         │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 4. Backend:                          │
│    - Find user by email              │
│    - Check if email verified         │
│    - Compare password (bcrypt)       │
│    - Check if not suspended          │
└────────┬─────────────────────────────┘
         │
         v
┌──────────────────────────────────────┐
│ 5. If valid:                         │
│    - Generate JWT token              │
│    - Return token + user data        │
│    - Redirect to Dashboard           │
│                                      │
│ If invalid:                          │
│    - Return error message            │
│    - Ask to retry                    │
└──────────────────────────────────────┘
```

---

## 🎯 Core Feature Workflows

### **1️⃣ Tuition Discovery & Search Flow**

```
User → Search Tab
         │
         ├─→ View available filters:
         │   ├─ Subject
         │   ├─ Class Level
         │   ├─ City
         │   ├─ Salary Range
         │   └─ Location Radius
         │
         ├─→ Select filters + Enter location
         │
         v
    API Call: GET /api/tuition/nearby
    Payload: { latitude, longitude, radius,
               subject, classLevel, city,
               salaryMin, salaryMax }
    │
    v
Backend MongoDB Query:
├─ Use $geoNear for location-based search
├─ Filter by subjects, class level, salary
├─ Exclude: inactive posts, closed posts
├─ Return: top matches sorted by distance
    │
    v
Display Results on Map:
├─ Show tuition markers on map
├─ List view with distance calculated
├─ Click marker → View details
    │
    v
User Actions:
├─ Apply for tuition
├─ Contact teacher
└─ View teacher profile

```

### **2️⃣ Matching System Flow**

```
Student finds Tuition Post
           │
           v
    Clicks "Apply" Button
           │
           v
POST /api/matches/request
├─ Create Match document
├─ Status: 'pending'
└─ Send notification to teacher
           │
           v
Teacher receives notification
           │
           ├─→ Accept → MATCH CONFIRMED
           │   ├─ Update Match.status = 'accepted'
           │   ├─ Create ChatRoom
           │   └─ Notify student
           │
           ├─→ Reject → MATCH REJECTED
           │   ├─ Update Match.status = 'rejected'
           │   └─ Notify student
           │
           └─→ View Student Profile
               ├─ Check ratings
               └─ Check reviews

```

### **3️⃣ Real-time Chat Flow**

```
┌─ Match Accepted ─────────────┐
│                              │
v                              v
Teacher              Student
   │                    │
   └────── Create ChatRoom ────────┐
           │                        │
           v                        v
    Both enter Chat Tab      (WebSocket Connection)
           │                        │
           ├─→ See conversation history
           │   (via MongoDB ChatRoom)
           │
           ├─→ Type message + Send
           │   │
           │   v (Socket.io emit)
           │   Backend broadcasts to both
           │   │
           │   v
           │   Message saved to MongoDB
           │   Message appears in both UIs
           │
           └─→ Disconnect/Close
               Chat remains in history
```

### **4️⃣ Rating & Review Flow**

```
After Tuition Session Completes:
           │
           v
   Student rates teacher
   ├─ Select 1-5 stars
   ├─ Write feedback text
   └─ Submit
           │
           v
POST /api/reviews/create
├─ Create Review document
├─ Update TeacherProfile:
│  ├─ Recalculate ratingAverage
│  └─ Increment ratingCount
└─ Send notification to teacher
           │
           v
Teacher receives notification
└─ Rating reflected in profile
```

### **5️⃣ Admin Approval Workflow**

```
User Registers
   │
   v
Approval Status = 'pending'
   │
   v
Admin Dashboard → Profile Approvals Tab
   │
   ├─→ Review user details
   ├─→ Check profile completeness
   ├─→ Make decision:
   │
   ├─→ APPROVE:
   │  ├─ User.isApproved = true
   │  └─ User can post/apply
   │
   ├─→ REJECT:
   │  └─ User blocked from posting
   │
   └─→ Tuition posts follow same flow
      (requires admin approval before visibility)
```

---

## 🔌 API Endpoints Overview

### **Authentication Endpoints**
```
POST   /api/auth/register        # User registration
POST   /api/auth/login           # User login
POST   /api/auth/verify-otp      # Email verification
POST   /api/auth/resend-otp      # Resend OTP code
POST   /api/auth/logout          # Logout & token invalidation
POST   /api/auth/refresh-token   # Refresh JWT token
```

### **Profile Endpoints**
```
GET    /api/profile/me           # Get current user profile
PUT    /api/profile/me           # Update current user profile
POST   /api/profile/avatar       # Upload profile avatar
GET    /api/profile/top-teachers # Get top-rated teachers
GET    /api/profile/:userId      # Get user profile details
```

### **Tuition Endpoints**
```
POST   /api/tuition              # Create tuition post
GET    /api/tuition              # List user's tuition posts
GET    /api/tuition/:id          # Get tuition post details
PUT    /api/tuition/:id          # Update tuition post
DELETE /api/tuition/:id          # Delete tuition post
GET    /api/tuition/nearby       # Location-based search
```

### **Chat Endpoints**
```
GET    /api/chat/rooms           # List chat rooms
POST   /api/chat/rooms           # Create new chat room
GET    /api/chat/rooms/:roomId   # Get chat room & messages
POST   /api/chat/messages        # Send message
GET    /api/chat/messages/:roomId # Get message history
```

### **Match Endpoints**
```
POST   /api/matches/request      # Request match
PUT    /api/matches/:id/accept   # Accept match
PUT    /api/matches/:id/reject   # Reject match
GET    /api/matches              # Get user's matches
```

### **Admin Endpoints**
```
GET    /api/admin/dashboard      # Dashboard statistics
GET    /api/admin/profiles       # List pending profiles
PUT    /api/admin/profiles/:userId/approve    # Approve profile
PUT    /api/admin/profiles/:userId/reject     # Reject profile
PUT    /api/admin/users/:userId/suspend       # Suspend user
POST   /api/admin/notices        # Create announcement
GET    /api/admin/nid-verifications # List NID documents
PUT    /api/admin/nid/:id/verify # Verify teacher NID
```

### **Review Endpoints**
```
POST   /api/reviews              # Submit review
GET    /api/reviews/:teacherId   # Get teacher reviews
```

### **Notification Endpoints**
```
GET    /api/notifications        # Get user notifications
PUT    /api/notifications/:id/read # Mark as read
DELETE /api/notifications/:id    # Delete notification
```

---

## 🎨 Frontend UI/UX Flow

### **Navigation Structure**

```
┌────────────────────────────────────────────┐
│          EduConnect Dashboard              │
├────────────────────────────────────────────┤
│ [Sidebar]  │                               │
│ ──────────  │  ┌──────────────────────┐   │
│ TABS:       │  │                      │   │
│ • Home      │  │  ACTIVE TAB          │   │
│ • Search    │  │  CONTENT AREA        │   │
│ • Chat      │  │                      │   │
│ • Tuition   │  │                      │   │
│ • Profile   │  │                      │   │
│ ──────────  │  │                      │   │
│ MORE:       │  │                      │   │
│ • Settings  │  │                      │   │
│ • Help      │  │                      │   │
│ • Logout    │  │                      │   │
│             │  └──────────────────────┘   │
└────────────────────────────────────────────┘
```

### **Tab Workflows**

#### **Home Tab**
```
┌─────────────────────────────────────┐
│ Home Tab Content                    │
├─────────────────────────────────────┤
│ Greeting: "Welcome, [Name]!"        │
│                                     │
│ ┌─ NOTICES SECTION ─────────────┐  │
│ │ NoticeBoard Widget            │  │
│ │ • System announcements        │  │
│ │ • Priority badges             │  │
│ │ • Dismissible alerts          │  │
│ └───────────────────────────────┘  │
│                                     │
│ ┌─ TOP TEACHERS SECTION ────────┐  │
│ │ TopTeachers Widget (Carousel) │  │
│ │ • 5 highest-rated teachers    │  │
│ │ • Rank badges                 │  │
│ │ • Star ratings                │  │
│ │ • Subject tags                │  │
│ └───────────────────────────────┘  │
│                                     │
│ ┌─ FEATURED TUITIONS ───────────┐  │
│ │ • Quick action buttons        │  │
│ │ • Recent posts                │  │
│ │ • Personalized recommendations│  │
│ └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

#### **Search Tab**
```
┌─────────────────────────────────────┐
│ Search Tab                          │
├─────────────────────────────────────┤
│ FILTER SECTION:                     │
│ ┌─────────────────────────────────┐ │
│ │ Subject: [Dropdown]             │ │
│ │ Class Level: [Dropdown]         │ │
│ │ City: [Dropdown]                │ │
│ │ Salary: [Min] - [Max] slider    │ │
│ │ Radius: [Map radius selector]   │ │
│ │ [APPLY FILTERS] Button          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ MAP SECTION:                        │
│ ┌─────────────────────────────────┐ │
│ │ [OpenStreetMap]                 │ │
│ │ • User location marker          │ │
│ │ • Tuition markers with icons    │ │
│ │ • Radius circle overlay         │ │
│ │ • Zoom & pan controls           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ RESULTS LIST:                       │
│ ┌─────────────────────────────────┐ │
│ │ [1] Subject | Distance | $Salary│ │
│ │ [2] Subject | Distance | $Salary│ │
│ │ [3] Subject | Distance | $Salary│ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### **Chat Tab**
```
┌─────────────────────────────────────┐
│ Chat Tab - Active Conversations     │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ [Teacher 1] Last message...   →│ │
│ │ Updated: 2 mins ago           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [Teacher 2] Last message...   →│ │
│ │ Updated: 1 hour ago           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [Teacher 3] Last message...   →│ │
│ │ Updated: 3 days ago           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [No more conversations]             │
└─────────────────────────────────────┘

When clicked → Chat Detail Screen:
┌─────────────────────────────────────┐
│ [← Back] Teacher Name               │
├─────────────────────────────────────┤
│ Message History:                    │
│                                     │
│ [Teacher]: "Hello, when can we...?" │
│                                     │
│              [You]: "Tomorrow 5pm"  │
│                                     │
│ [Teacher]: "Perfect, see you then" │
│                                     │
├─────────────────────────────────────┤
│ [Type message...] [Send ►]          │
└─────────────────────────────────────┘
```

#### **Tuition Tab**
```
┌─────────────────────────────────────┐
│ Tuition Tab - My Posts              │
├─────────────────────────────────────┤
│ [+ CREATE NEW POST] Button          │
│                                     │
│ Active Posts:                       │
│ ┌─────────────────────────────────┐ │
│ │ [Post 1] Status: Active         │ │
│ │ 5 applicants | $500/month       │ │
│ │ [Edit] [View Applicants]        │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Closed Posts:                       │
│ ┌─────────────────────────────────┐ │
│ │ [Post 2] Status: Matched ✓      │ │
│ │ [View Match]                    │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### **Profile Tab**
```
┌─────────────────────────────────────┐
│ Profile Tab                         │
├─────────────────────────────────────┤
│ [Avatar Image]                      │
│ Name: [John Doe]                    │
│ Email: [john@example.com]           │
│ Role: [Teacher]                     │
│                                     │
│ Edit Mode (if own profile):         │
│ ┌─────────────────────────────────┐ │
│ │ [EDIT PROFILE] Button           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Teacher-Specific (if teacher):      │
│ ┌─────────────────────────────────┐ │
│ │ University: [XYZ University]    │ │
│ │ Subjects: [Math, Physics]       │ │
│ │ Availability: [Available]       │ │
│ │ Rating: ⭐⭐⭐⭐⭐ (4.8)          │ │
│ │ [⬆ Upload NID Image]            │ │
│ │ NID Status: ✓ Verified          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [LOGOUT] Button                     │
└─────────────────────────────────────┘
```

---

## 🛡️ Admin Dashboard Flow

### **Admin Dashboard Structure**

```
┌──────────────────────────────────────────────────┐
│ EduConnect Admin Dashboard                       │
├──────────────────────────────────────────────────┤
│ Tab Navigation:                                  │
│ [1. Overview] [2. Profiles] [3. Posts]           │
│ [4. NID] [5. Bans] [6. Notices] [7. Users]       │
├──────────────────────────────────────────────────┤
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 1: OVERVIEW (Dashboard Stats)          │  │
│ │ ├─ Total Users: 1,250                      │  │
│ │ ├─ Pending Approvals: 15                   │  │
│ │ ├─ Active Tuitions: 342                    │  │
│ │ ├─ Suspended Users: 3                      │  │
│ │ └─ Chart: Registrations over time          │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 2: PROFILE APPROVALS                   │  │
│ │ [List of pending user profiles]            │  │
│ │ For each:                                  │  │
│ │ ├─ User details                            │  │
│ │ ├─ Profile completeness check              │  │
│ │ ├─ [APPROVE] [REJECT] buttons              │  │
│ │ └─ Approval reason field                   │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 3: TUITION POSTS                       │  │
│ │ [List of pending tuition posts]            │  │
│ │ For each:                                  │  │
│ │ ├─ Post details                            │  │
│ │ ├─ Creator info                            │  │
│ │ ├─ [APPROVE] [REJECT] buttons              │  │
│ │ └─ Feedback option                         │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 4: NID VERIFICATION                    │  │
│ │ [List of NID uploads to verify]            │  │
│ │ For each:                                  │  │
│ │ ├─ NID image preview                       │  │
│ │ ├─ Teacher details                         │  │
│ │ ├─ [VERIFY] [REJECT] buttons               │  │
│ │ └─ Verification notes field                │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 5: USER BANS                           │  │
│ │ [List of all banned users]                 │  │
│ │ For each:                                  │  │
│ │ ├─ Username                                │  │
│ │ ├─ Ban reason                              │  │
│ │ ├─ Ban date                                │  │
│ │ └─ [UNBAN] button                          │  │
│ │                                            │  │
│ │ [Ban new user] search field                │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 6: NOTICES                             │  │
│ │ [Create new announcement]                  │  │
│ │ Form:                                      │  │
│ │ ├─ Title                                   │  │
│ │ ├─ Description                             │  │
│ │ ├─ Type (Alert, Maintenance, Promotion)   │  │
│ │ ├─ Priority (Low, Medium, High)            │  │
│ │ ├─ Image upload                            │  │
│ │ └─ [PUBLISH] button                        │  │
│ │                                            │  │
│ │ [Recent notices list]                      │  │
│ └────────────────────────────────────────────┘  │
│                                                  │
│ ┌────────────────────────────────────────────┐  │
│ │ TAB 7: ALL USERS                           │  │
│ │ [List of all registered users]             │  │
│ │ For each:                                  │  │
│ │ ├─ Username                                │  │
│ │ ├─ Role (Student/Teacher)                  │  │
│ │ ├─ Status (Active/Suspended)               │  │
│ │ ├─ Joined date                             │  │
│ │ └─ [DETAILS] [SUSPEND] buttons             │  │
│ └────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

---

## 📡 Real-time Communication (WebSocket)

### **Socket.io Architecture**

```
Frontend (Flutter)              Backend (Node.js)
    │                                │
    ├─→ Connect to Socket.io ────────┤
    │   (URL: http://localhost:3000) │
    │                                │
    ├─→ Emit 'join_chat'        ────→ Listen for join
    │   Data: { roomId }             │
    │                                │
    ├─→ Emit 'send_message'     ────→ Process message
    │   Data: { message, roomId }    │
    │          │
    │          v
    │     Save to MongoDB
    │          │
    │          ├─→ Broadcast to recipients
    │          │
    v←─────────┴─ Emit 'receive_message'
  Display message
```

---

## 🔑 Key Implementation Features

### **Completed Features** ✅

| Feature | Frontend | Backend | Database |
|---------|----------|---------|----------|
| User Authentication | ✅ | ✅ | ✅ |
| Profile Management | ✅ | ✅ | ✅ |
| Tuition Posting | ✅ | ✅ | ✅ |
| Location-Based Search | ✅ | ✅ | ✅ |
| Real-time Chat | ✅ | ✅ | ✅ |
| Matching System | ✅ | ✅ | ✅ |
| Rating & Reviews | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | ✅ |
| Admin Dashboard | ✅ | ✅ | ✅ |
| Notice Board | ✅ | ✅ | ✅ |
| Top Teachers | ✅ | ✅ | ✅ |
| NID Upload & Verification | ✅ | ✅ | ✅ |
| OTP Email Verification | ✅ | ✅ | ✅ |
| JWT Authentication | ✅ | ✅ | ✅ |
| Parent Controls | ✅ | ✅ | ✅ |
| Content Moderation | ✅ | ✅ | ✅ |
| Rate Limiting | ✅ | ✅ | ✅ |
| API Documentation (OpenAPI/Swagger) | - | ✅ | - |

---

## 🔒 Security Implementation

### **Authentication & Authorization**
- **JWT Tokens**: 7-day expiry with refresh mechanism
- **Password Hashing**: bcrypt with salt rounds
- **Secure Storage**: flutter_secure_storage for tokens
- **Email Verification**: OTP-based with 10-minute expiry
- **Admin Middleware**: Role-based access control

### **Data Protection**
- **CORS**: Configured for cross-origin requests
- **Rate Limiting**: Prevents brute-force attacks
- **Content Moderation**: Filters inappropriate content
- **Input Validation**: Server-side validation on all endpoints
- **Error Handling**: Secure error messages (no sensitive data leaks)

### **API Security**
- **Swagger UI Protection**: Secret key required in production
- **Authorization Headers**: JWT in Authorization header
- **HTTPS Ready**: Configure in production deployment
- **User Data Serialization**: Password excluded from responses

---

## 📊 Data Flow Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                        USER REQUEST                          │
│                    (Flutter App)                             │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         v
         ┌───────────────────────────────────┐
         │  HTTP/WebSocket Request           │
         │  • URL: api.educonnect.local      │
         │  • Headers: Authorization: JWT    │
         │  • Body: JSON data                │
         └────────┬────────────────────────┘
                  │
                  v
    ┌─────────────────────────────────────────┐
    │  Express Router (Node.js)               │
    │  Route matching: /api/[resource]/[id]   │
    └────────┬────────────────────────────────┘
             │
             v
    ┌─────────────────────────────────────────┐
    │  Middleware Chain                       │
    │  1. CORS                                │
    │  2. Parse JSON                          │
    │  3. JWT Auth (if required)              │
    │  4. Rate Limit                          │
    │  5. Validation                          │
    │  6. Admin Check (if required)           │
    └────────┬────────────────────────────────┘
             │
             v
    ┌─────────────────────────────────────────┐
    │  Controller Logic                       │
    │  ├─ Validate inputs                     │
    │  ├─ Query database                      │
    │  ├─ Business logic                      │
    │  └─ Prepare response                    │
    └────────┬────────────────────────────────┘
             │
             v
    ┌─────────────────────────────────────────┐
    │  MongoDB Query                          │
    │  ├─ Find, Insert, Update, Delete        │
    │  ├─ Geospatial queries ($geoNear)       │
    │  └─ Aggregation pipelines               │
    └────────┬────────────────────────────────┘
             │
             v
    ┌─────────────────────────────────────────┐
    │  MongoDB Database                       │
    │  (Document storage)                     │
    └────────┬────────────────────────────────┘
             │
             v (Response)
    ┌─────────────────────────────────────────┐
    │  JSON Response                          │
    │  ├─ Status: 200, 400, 500, etc.         │
    │  ├─ Data: Result set                    │
    │  └─ Error: Error message (if failed)    │
    └────────┬────────────────────────────────┘
             │
             v
    ┌─────────────────────────────────────────┐
    │  Flutter App                            │
    │  ├─ Parse JSON response                 │
    │  ├─ Update UI                           │
    │  ├─ Cache data (if needed)              │
    │  └─ Show notifications                  │
    └─────────────────────────────────────────┘
```

---

## 🚀 Deployment Architecture

### **Production Setup**

```
┌─────────────────────────────────────────────────────────┐
│                  PRODUCTION DEPLOYMENT                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Frontend (Flutter)                                     │
│  ├─ Web: Hosted on Firebase/Netlify/Vercel            │
│  ├─ Mobile: iOS/Android stores                        │
│  └─ Desktop: .exe/.dmg/.deb distributables             │
│                                                         │
│  ↓ (HTTPS API Calls)                                   │
│                                                         │
│  Backend (Node.js)                                     │
│  ├─ Server: AWS/DigitalOcean/Heroku                   │
│  ├─ Environment: Production (NODE_ENV=production)      │
│  └─ Process: PM2/forever (auto-restart)                │
│                                                         │
│  ↓ (Mongoose Connection String)                        │
│                                                         │
│  Database (MongoDB)                                    │
│  ├─ MongoDB Atlas (Cloud) OR Self-hosted               │
│  ├─ Connection: SSL/TLS encrypted                      │
│  ├─ Replication: 3-node replica set                    │
│  └─ Backups: Daily automated backups                   │
│                                                         │
│  ↓ (Socket.io on port 3001)                            │
│                                                         │
│  WebSocket Server (Real-time)                          │
│  ├─ Same Node.js server or separate                    │
│  ├─ Redis for message queue (optional)                 │
│  └─ Sticky sessions for scaling                        │
│                                                         │
│  ↓ (SMTP Server)                                       │
│                                                         │
│  Email Service (Nodemailer)                            │
│  ├─ Gmail/SendGrid/AWS SES                             │
│  └─ OTP & notification emails                          │
│                                                         │
│  ↓ (CDN)                                               │
│                                                         │
│  File Storage                                          │
│  ├─ AWS S3 / Google Cloud Storage                      │
│  ├─ Profile avatars                                    │
│  ├─ NID documents                                      │
│  └─ Announcement images                                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 📈 Performance Considerations

### **Optimization Implemented**
- **Database Indexing**: On email, userId, location fields
- **API Response Pagination**: Limit results per request
- **Image Compression**: Avatar resizing before upload
- **Caching**: Local storage for user data & settings
- **Lazy Loading**: UI widgets load on-demand
- **WebSocket Efficiency**: Binary message format support

### **Scalability Strategies**
- **Load Balancing**: Nginx/HAProxy for API requests
- **Database Sharding**: Partition by userId ranges
- **Microservices Ready**: Modular controller design
- **Caching Layer**: Redis for session/chat data
- **CDN Integration**: Content delivery for static assets

---

## 🧪 Testing Infrastructure

### **Test Files**
- `backend/test-health.js` - Server health checks
- `backend/test-simple.js` - Basic API smoke tests
- Jest configuration for test running

### **Recommended Test Coverage**
- Unit tests: Controllers & utilities (70% coverage)
- Integration tests: API endpoints (80% coverage)
- E2E tests: Critical user flows (50% coverage)

---

## 🔗 Technology Dependencies

### **Frontend (Flutter)**
```yaml
Core:
  - flutter (3.9+)
  - dart (3.0+)

State Management:
  - flutter_bloc (8.1.0)
  - get_it (7.6.7)

Networking:
  - http (1.1.0)
  - dio (5.0.0)
  - socket_io_client (2.0.2)

Storage:
  - flutter_secure_storage (9.0.0)
  - shared_preferences (2.2.0)

Location & Maps:
  - geolocator (9.0.2)
  - flutter_map (5.0.0)
  - latlong2 (0.9.0)

UI & Media:
  - image_picker (1.0.4)
  - image_cropper (11.0.0)

Routing:
  - go_router (14.0.0)

Utilities:
  - intl (0.19.0)
  - path_provider (2.1.2)
```

### **Backend (Node.js)**
```json
Core:
  - express (routing)
  - dotenv (env vars)

Database:
  - mongoose (MongoDB ORM)

Authentication:
  - jsonwebtoken (JWT)
  - bcrypt (password hashing)

Email:
  - nodemailer (SMTP)

Real-time:
  - socket.io (WebSocket)

Documentation:
  - swagger-ui-express
  - yamljs

Development:
  - jest (testing)
  - nodemon (auto-restart)
```

---

## 📝 Future Enhancements

### **Phase 3: Advanced Features**
- [ ] Payment Integration (Stripe/PayPal)
- [ ] Video Call (Agora/Twilio)
- [ ] AI Recommendations Engine
- [ ] Subscription Plans
- [ ] Analytics Dashboard
- [ ] Mobile App Push Notifications
- [ ] Two-Factor Authentication (2FA)

### **Phase 4: Platform Growth**
- [ ] Teacher Certification Program
- [ ] Affiliate Referral System
- [ ] Premium Features
- [ ] Multi-language Support
- [ ] Social Features (Follow, Followers)
- [ ] Tuition Group Classes
- [ ] Winter/Summer Campaigns

---

## 📞 Support & Troubleshooting

### **Common Issues**
1. **JWT Token Expired** → User re-login or token refresh endpoint
2. **Socket.io Connection Failed** → Check WebSocket URL & CORS config
3. **MongoDB Connection Error** → Verify connection string & network access
4. **Email OTP Not Received** → Check Nodemailer SMTP settings
5. **Location Services Disabled** → Request location permissions from user

### **Debug Mode**
- Backend: Enable console.log in server.js request logger
- Frontend: Use Flutter DevTools for widget inspection
- Database: Use MongoDB Compass to browse collections

---

## ✅ Conclusion

**EduConnect** is a **fully-featured tuition marketplace** with:
- ✅ Secure user authentication system
- ✅ Advanced location-based search
- ✅ Real-time messaging via WebSockets
- ✅ Complete admin governance system
- ✅ Comprehensive rating & review system
- ✅ Responsive multi-platform UI
- ✅ Production-ready API documentation

The application demonstrates **enterprise-level architecture** with proper separation of concerns, security best practices, and scalable design patterns.

---

**Report Generated:** December 8, 2025  
**By:** GitHub Copilot  
**Status:** ✅ Complete & Ready for Review
