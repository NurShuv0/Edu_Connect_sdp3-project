# EduConnect - Android Setup & Installation Guide

## ✅ What's Been Fixed

### Flutter Issues Resolved:
1. ✅ **setState() after dispose** - Added mounted checks in `chat_tab.dart`
2. ✅ **Socket.io connection errors** - Fixed in `chat_service.dart`
3. ✅ **Flutter upgraded** to 3.38.5
4. ✅ **Dependencies installed** successfully
5. ✅ **Backend running** on port 5000 (Node.js + MongoDB)

### Current Status:
- Backend: ✅ Running
- Frontend (Chrome): ✅ Running  
- Frontend (Android): 🔄 In Progress - Downloading Android SDK

---

## 🔧 Android Device Connection Troubleshooting

### If Your Phone Isn't Detected:

1. **Enable Developer Mode on Android:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"
   - Enable "Install from Unknown Sources"

2. **Check USB Connection:**
   - Disconnect and reconnect phone
   - Select "Transfer files" or "Android System" when prompted
   - Run: `flutter devices` to verify detection

3. **Manual Installation (If Phone Not Detected):**
   - An APK will be built automatically
   - Transfer it to your phone via USB or cloud
   - On phone: Settings → Install Unknown Apps → Allow for file manager
   - Tap the APK to install

---

## 📦 Installation Steps

### Step 1: Verify Setup
```bash
cd d:\MY_CODE\EduConnect
flutter doctor
```

### Step 2: Connect Phone
- Plug USB cable to phone
- Enable USB Debugging (see above)
- Run: `flutter devices`

### Step 3: Run on Phone
```bash
cd d:\MY_CODE\EduConnect
flutter run
# Or if device not detected, build APK:
flutter build apk --debug
```

### Step 4: Access the App
- Once running on phone, login with credentials:
  - Email: test@example.com (or any registered account)
  - Password: Your password
  - Role: Student or Teacher

---

## 🎯 Features to Test

### Student:
1. Login → Profile Setup
2. Create Tuition Post
3. Browse Teachers
4. Chat with Teachers

### Teacher:
1. Login → Profile Setup
2. Browse Student Posts
3. Apply to Posts
4. Chat with Students

### Admin:
1. Login (admin@educonnect.com)
2. Review Pending Posts
3. Approve/Reject Applications
4. View Analytics

---

## 🔗 Backend API URL

The app is configured to use:
```
http://127.0.0.1:5000/api
```

**Important:** When testing on a physical Android phone:
- If on same WiFi: Use your computer's IP (e.g., `http://192.168.x.x:5000/api`)
- If testing locally: The app will auto-adjust URLs

---

## 🆘 Common Issues & Solutions

### "No Implementation Found for Method getApplicationDocumentsDirectory"
- **Solution:** This is fixed. Runs on web/desktop only, Android uses native implementation.

### "setState() called after dispose()"
- **Solution:** This is fixed in `chat_tab.dart` and `chat_service.dart`.

### Phone Not Showing in `flutter devices`
- **Solution:** 
  1. Check Settings → Developer Options → USB Debugging is ON
  2. Disconnect/reconnect USB
  3. Or build APK and install manually

### Socket.io connection failing
- **Solution:** Backend must be running on port 5000
- Check: `http://127.0.0.1:5000/` in browser (should return JSON)

---

## 📱 Build & Install Manually

```bash
# Build APK
flutter build apk --debug

# APK location:
# d:\MY_CODE\EduConnect\build\app\outputs\flutter-apk\app-debug.apk

# Transfer to phone and install:
# - Via ADB: adb install <path-to-apk>
# - Via USB: Copy file to phone, open with file manager
```

---

## 🚀 Next Steps

1. Wait for Android SDK download to complete (currently running)
2. Once SDK is ready, app will build automatically
3. Connect phone and run: `flutter run`
4. Test all features (login, post, chat, etc.)

---

## 📞 Support

If you encounter issues:
1. Check that backend is running: `curl http://127.0.0.1:5000/`
2. Check Flutter setup: `flutter doctor -v`
3. Check device connection: `flutter devices`
4. Check logs: `flutter run -v`

---

**Status:** SDK Download in progress... Check back in 3-5 minutes for completion!
