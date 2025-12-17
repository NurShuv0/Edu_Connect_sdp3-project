import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/chat_service.dart';
import 'package:test_app/src/core/services/auth_service.dart';
import 'package:test_app/src/ui/chat/chat_room_page.dart';
import 'package:test_app/src/core/widgets/app_avatar.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final chat = GetIt.instance<ChatService>();

  bool loading = true;
  List rooms = [];

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    setState(() => loading = true);

    try {
      final res = await chat.getMyRooms();
      rooms = res;
    } catch (e) {
      print("Chat rooms load error: $e");
      rooms = [];
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (rooms.isEmpty) {
      return const Center(child: Text("No active chats yet"));
    }

    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (_, i) {
        final r = rooms[i];

        // Extract IDs properly
        final studentId = r["studentId"] is Map
            ? (r["studentId"]["_id"] ?? "").toString()
            : (r["studentId"] ?? "").toString();
        final teacherId = r["teacherId"] is Map
            ? (r["teacherId"]["_id"] ?? "").toString()
            : (r["teacherId"] ?? "").toString();

        final auth = GetIt.instance<AuthService>();
        final currentUserId = (auth.user?.id ?? "").toString();

        // Determine if current user is student or teacher
        final isStudent = currentUserId == studentId;
        final isTeacher = currentUserId == teacherId;

        // Get partner's name - prioritize populated user objects
        String partnerName = "Chat Partner";

        if (isStudent) {
          // Student viewing chat - show teacher name
          if (r["teacherId"] is Map && r["teacherId"]["name"] != null) {
            partnerName = r["teacherId"]["name"];
          } else if (r["matchId"] is Map &&
              r["matchId"]["teacherName"] != null) {
            partnerName = r["matchId"]["teacherName"];
          } else {
            partnerName = "Teacher";
          }
        } else if (isTeacher) {
          // Teacher viewing chat - show student name
          if (r["studentId"] is Map && r["studentId"]["name"] != null) {
            partnerName = r["studentId"]["name"];
          } else if (r["matchId"] is Map &&
              r["matchId"]["studentName"] != null) {
            partnerName = r["matchId"]["studentName"];
          } else {
            partnerName = "Student";
          }
        }

        return ListTile(
          leading: AppAvatar(name: partnerName, radius: 20),
          title: Text(partnerName),
          subtitle: const Text("Tap to open chat"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatRoomPage(roomId: r["_id"], partnerName: partnerName),
              ),
            );
          },
        );
      },
    );
  }
}
