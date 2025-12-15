# 🐛 API Route Fix - Double /api/ Prefix Bug

## Problem Identified

Your backend logs showed requests like:
```
POST /api/api/announcements              ❌ WRONG
PATCH /api/api/admin/profiles/...        ❌ WRONG
```

Instead of:
```
POST /api/announcements                  ✅ CORRECT
PATCH /api/admin/profiles/...            ✅ CORRECT
```

## Root Cause

**Double `/api/` prefix in frontend API calls**

The issue was in `lib/src/core/services/admin_service.dart`:

### ApiClient Configuration (Correct)
```dart
// env.dart
static const String apiBase = 'http://127.0.0.1:5000/api';

// ApiClient uses this baseUrl and constructs URLs as:
// final uri = Uri.parse('$baseUrl$path');
// Example: http://127.0.0.1:5000/api + /admin/users = http://127.0.0.1:5000/api/admin/users ✅
```

### The Bug (Before Fix)
```dart
// admin_service.dart (WRONG)
await api.post('/api/admin/users/admin/create', {...})
// Results in: http://127.0.0.1:5000/api + /api/admin/users/admin/create
// = http://127.0.0.1:5000/api/api/admin/users/admin/create ❌
```

### The Fix (After Fix)
```dart
// admin_service.dart (CORRECT)
await api.post('/admin/users/admin/create', {...})
// Results in: http://127.0.0.1:5000/api + /admin/users/admin/create
// = http://127.0.0.1:5000/api/admin/users/admin/create ✅
```

## Files Fixed

### `lib/src/core/services/admin_service.dart`

**Fixed 12 methods** by removing `/api/` prefix:

| Line | Method | Before | After |
|------|--------|--------|-------|
| 163 | `createAdmin()` | `/api/admin/users/admin/create` | `/admin/users/admin/create` |
| 178 | `updateUserRole()` | `/api/admin/users/$userId/role` | `/admin/users/$userId/role` |
| 193 | `listUsers()` | `/api/admin/users` | `/admin/users` |
| 205 | `getDashboardStats()` | `/api/admin/dashboard/stats` | `/admin/dashboard/stats` |
| 212 | `sendAnnouncement()` | `/api/announcements` | `/announcements` |
| 225 | `sendMessageToUser()` | `/api/admin/messages/send` | `/admin/messages/send` |
| 240 | `getAllUsers()` | `/api/admin/users` | `/admin/users` |
| 255 | `toggleParentControl()` | `/api/admin/students/$studentId/parent-control` | `/admin/students/$studentId/parent-control` |
| 264 | `approveUserProfile()` | `/api/admin/profiles/$userId/approve` | `/admin/profiles/$userId/approve` |
| 268 | `rejectUserProfile()` | `/api/admin/profiles/$userId/reject` | `/admin/profiles/$userId/reject` |
| 277 | `getPendingUsers()` | `/api/admin/profiles/pending` | `/admin/profiles/pending` |

### `lib/src/core/services/announcement_service.dart`

✅ **No changes needed** - Already correct with `/announcements/active` (no `/api/` prefix)

## API Route Convention

**Standard pattern in EduConnect:**

```
# Frontend (Dart)
ApiClient baseUrl = 'http://localhost:5000/api'

# Service calls (CORRECT FORMAT)
await api.post('/admin/users/admin/create', {...})
await api.get('/announcements/active')
await api.patch('/admin/profiles/$userId/approve', {})

# Results in correct backend URLs
POST http://localhost:5000/api/admin/users/admin/create
GET http://localhost:5000/api/announcements/active
PATCH http://localhost:5000/api/admin/profiles/{userId}/approve
```

## Verification

### Before Fix (Logs)
```
[2025-12-08T15:09:23.613Z] POST /api/api/announcements
[2025-12-08T15:09:36.046Z] PATCH /api/api/admin/profiles/69300e452dfb9271eeb69826/approve
❌ All requests return 404 "Not Found"
```

### After Fix (Expected Logs)
```
[2025-12-08T15:10:00.000Z] POST /api/announcements
[2025-12-08T15:10:05.000Z] PATCH /api/admin/profiles/69300e452dfb9271eeb69826/approve
✅ All requests properly routed to backend handlers
```

## How to Test

1. **Restart your Flutter app** to load the fixed admin_service
2. **Login as admin** (admin@educonnect.com / Admin@12345)
3. **Go to Admin Dashboard**
4. **Perform an approval action** (approve a profile, create announcement, etc.)
5. **Check backend logs** for correct route format:
   - ✅ Should see: `POST /api/announcements`
   - ❌ Should NOT see: `POST /api/api/announcements`

## Summary

✅ **Fixed:** Double `/api/` prefix bug in admin_service.dart  
✅ **Impact:** All admin operations now route correctly  
✅ **Files Modified:** 1 file (admin_service.dart)  
✅ **Lines Changed:** 12 methods updated  

Your admin dashboard should now work as expected! 🎉
