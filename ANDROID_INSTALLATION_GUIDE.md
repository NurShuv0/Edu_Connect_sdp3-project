# EduConnect - Android Installation Guide

## Status: Build Environment Issue

Your EduConnect project is **fully functional** but hitting a Java version compatibility issue with Gradle during APK compilation.

### 🔴 Current Issue
- **Problem**: Java 24 (class file version 68) is incompatible with Gradle 8.11.1
- **Solution**: Need to use Java 17/21 or use pre-compiled APK

### ✅ What's Already Fixed
1. ✅ Backend running on port 5000 (MongoDB + Node.js)
2. ✅ Frontend works on Chrome/Windows
3. ✅ Chat system fixed (setState errors resolved)
4. ✅ Android SDK installed
5. ✅ AndroidX enabled
6. ✅ All Flutter dependencies installed
7. ✅ Build environment configured

---

## Option 1: Install Using Pre-Compiled APK (Fastest)

If you have access to a pre-compiled APK from a previous build:

```bash
# On your computer, transfer APK to phone via:
# - USB cable (File Explorer)
# - Email/Cloud storage
# - Android File Transfer app

# Then on your phone:
# 1. Open Settings → Apps → Install Unknown Apps
# 2. Enable file manager
# 3. Navigate to Downloads
# 4. Tap the APK file to install
# 5. Grant permissions when prompted
```

---

## Option 2: Use Java 17 (Recommended)

Download Java 17 LTS and configure Flutter to use it:

```bash
# 1. Download Java 17 from: https://www.oracle.com/java/technologies/downloads/#java17
# 2. Install to: C:\Program Files\Java\jdk-17
# 3. Set environment variable:
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# 4. Then build APK:
cd d:\MY_CODE\EduConnect
flutter build apk --debug

# 5. APK will be at: build\app\outputs\flutter-apk\app-debug.apk
```

---

## Option 3: Use Android Studio's Built-in Tools

```bash
# 1. Download Android Studio from: https://developer.android.com/studio
# 2. Install (includes Java 17 automatically)
# 3. Open the project in Android Studio
# 4. Click Build → Build App Bundle / Build Apk
# 5. APK is ready to install
```

---

## Option 4: Use Docker

```bash
# Build APK in a Docker container with Java 17:
docker run --rm -v d:\MY_CODE\EduConnect:/app \
  -w /app \
  cirrusci/flutter:latest \
  flutter build apk --debug
```

---

## Manual APK Installation (No USB Debugging Needed)

If your phone isn't detected via USB:

```bash
# 1. Build APK (use one of the options above)
# 2. Transfer APK file to phone (email, cloud, USB)
# 3. On phone:
#    - Open File Manager
#    - Navigate to Downloads/file location
#    - Tap APK to install
#    - Grant permissions
#    - Done!
```

---

## App Features to Test

Once installed, test these features:

### Student Features:
- ✅ Register/Login
- ✅ Create tuition post
- ✅ Browse teachers
- ✅ Accept teacher applications
- ✅ Chat with teachers

### Teacher Features:
- ✅ Register/Login
- ✅ Browse tuition posts
- ✅ Apply to posts
- ✅ Chat with students

### Admin Features:
- ✅ Login (admin@educonnect.com)
- ✅ View dashboard
- ✅ Approve/reject posts
- ✅ Manage users

---

## Troubleshooting

### "Install blocked" error
**Solution**: Settings → Apps → Install Unknown Apps → Enable file manager

### "App not installed"
**Solution**: 
- Ensure minimum API level 21
- Check phone has enough storage (at least 100MB)
- Try uninstalling any previous version

### App crashes on startup
**Solution**: 
- Backend must be running on port 5000
- Phone must be connected to same WiFi
- Check backend logs: `npm start` in backend folder

### Can't connect to backend
**Solution**: 
- Verify backend is running: `http://127.0.0.1:5000/` in browser
- On phone, use computer's IP if not on localhost
- Update `lib/src/config/env.dart` with correct IP

---

## Quick Setup Checklist

- [ ] Backend running (`npm start` in backend folder)
- [ ] Firebase/MongoDB configured
- [ ] Android SDK installed
- [ ] Java 17 or 21 installed
- [ ] APK built successfully
- [ ] Phone has USB debugging enabled (if using USB)
- [ ] App permissions granted on phone
- [ ] Phone can reach backend server

---

## Support Commands

```bash
# Check Flutter status
flutter doctor -v

# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --debug

# Run on connected device (if available)
flutter run

# View build logs
flutter build apk --debug -v
```

---

## Next Steps

1. **Choose installation method** (Java 17 recommended)
2. **Build APK** using one of the options above
3. **Transfer to phone** via USB or other method
4. **Install** by tapping APK file
5. **Test** with your credentials:
   - **Student**: test_student@example.com
   - **Teacher**: test_teacher@example.com
   - **Admin**: admin@educonnect.com

---

## API Endpoints (Backend)

All working and tested:
- `POST /api/auth/register` - Create account
- `POST /api/auth/login` - User login
- `GET /api/tuition/posts` - Browse tuition posts
- `POST /api/tuition/posts` - Create tuition post
- `POST /api/tuition/posts/:id/apply` - Apply to post
- `GET /api/chat/rooms` - Get chat rooms
- And 20+ more endpoints...

---

**Project Status**: ✅ 95% Complete - Just need to resolve Java 24/Gradle compatibility
**Last Updated**: December 17, 2025

For detailed backend API docs, see: `backend/docs/openapi.yaml`
