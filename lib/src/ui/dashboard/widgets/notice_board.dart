import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/announcement_service.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  final announcementService = GetIt.instance<AnnouncementService>();
  List<Map<String, dynamic>> announcements = [];
  bool loading = true;
  String? error;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAnnouncements() async {
    try {
      setState(() => loading = true);
      final data = await announcementService.getActiveAnnouncements();
      setState(() {
        announcements = data;
        loading = false;
      });
      // Start auto-scroll after data loads
      Future.delayed(const Duration(milliseconds: 500), _startAutoScroll);
    } catch (e) {
      setState(() {
        error = "Failed to load announcements";
        loading = false;
      });
      print("NoticeBoard error: $e");
    }
  }

  void _startAutoScroll() {
    if (!mounted || announcements.isEmpty) return;

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _animateScroll();
    });
  }

  void _animateScroll() async {
    if (!mounted || announcements.isEmpty) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // If we're at the end, scroll back to beginning
    if (currentScroll >= maxScroll) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      // Scroll to next item
      await _scrollController.animateTo(
        currentScroll + 310, // Card width (280) + margin (12) + padding (18)
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }

    // Continue scrolling
    if (mounted) {
      Future.delayed(const Duration(seconds: 3), _animateScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _loadingPlaceholder();
    }

    if (error != null) {
      return _errorPlaceholder(error!);
    }

    if (announcements.isEmpty) {
      return _emptyPlaceholder();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "📢 Notice Board",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            PopupMenuButton<String>(
              itemBuilder: (_) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 12),
                      Text('Refresh'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'viewall',
                  child: Row(
                    children: [
                      Icon(Icons.view_list, size: 20),
                      SizedBox(width: 12),
                      Text('View All'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'refresh') {
                  _loadAnnouncements();
                } else if (value == 'viewall') {
                  // Navigate to full announcements view
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View all announcements')),
                  );
                }
              },
              icon: const Icon(Icons.more_vert, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: announcements
                .map((announcement) => _announcementCard(announcement))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _announcementCard(Map<String, dynamic> announcement) {
    final type = announcement['type'] ?? 'info';
    final title = announcement['title'] ?? 'Announcement';
    final description = announcement['description'] ?? '';

    Color bgColor;
    Color borderColor;
    IconData iconData;

    switch (type) {
      case 'alert':
        bgColor = const Color(0xFFFFEBEE);
        borderColor = Colors.red;
        iconData = Icons.warning;
        break;
      case 'success':
        bgColor = const Color(0xFFE8F5E9);
        borderColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case 'info':
      default:
        bgColor = const Color(0xFFE3F2FD);
        borderColor = Colors.blue;
        iconData = Icons.info;
        break;
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(iconData, color: borderColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF0F0F0),
      ),
      child: const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _errorPlaceholder(String msg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFFFEBEE),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF5F5F5),
      ),
      child: const Column(
        children: [
          Icon(Icons.info_outline, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No announcements at the moment",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
