import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/top_teachers_service.dart';
import 'package:test_app/src/ui/dashboard/pages/all_teachers_page.dart';

class TopTeachers extends StatefulWidget {
  const TopTeachers({super.key});

  @override
  State<TopTeachers> createState() => _TopTeachersState();
}

class _TopTeachersState extends State<TopTeachers> {
  final topTeachersService = GetIt.instance<TopTeachersService>();
  List<Map<String, dynamic>> teachers = [];
  bool loading = true;
  String? error;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadTopTeachers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTopTeachers() async {
    try {
      setState(() => loading = true);
      final data = await topTeachersService.getTopTeachers(limit: 5);
      setState(() {
        teachers = data;
        loading = false;
      });
      // Start auto-scroll after data loads
      Future.delayed(const Duration(milliseconds: 500), _startAutoScroll);
    } catch (e) {
      setState(() {
        error = "Failed to load top teachers";
        loading = false;
      });
      print("TopTeachers error: $e");
    }
  }

  void _startAutoScroll() {
    if (!mounted || teachers.isEmpty) return;

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _animateScroll();
    });
  }

  void _animateScroll() async {
    if (!mounted || teachers.isEmpty) return;

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
        currentScroll + 320, // Card width (300) + margin (20)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "⭐ Top Rated Teachers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllTeachersPage()),
                );
              },
              child: const Text(
                "View All",
                style: TextStyle(color: Colors.indigo, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (loading)
          _loadingPlaceholder()
        else if (error != null)
          _errorPlaceholder(error!)
        else if (teachers.isEmpty)
          _emptyPlaceholder()
        else
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: teachers
                  .asMap()
                  .entries
                  .map((entry) => _teacherCard(entry.key + 1, entry.value))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _teacherCard(int rank, Map<String, dynamic> teacher) {
    final name = teacher['name'] ?? 'Unknown';
    final rating = (teacher['ratingAverage'] ?? 0.0).toDouble();
    final ratingCount = teacher['ratingCount'] ?? 0;
    final subjects =
        (teacher['subjects'] as List?)?.join(", ") ?? "No subjects";
    final university = teacher['university'] ?? '';

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank Badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Teacher Info
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (university.isNotEmpty)
            Text(
              university,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 6),
          Text(
            subjects,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Rating Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($ratingCount)',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.indigo;
    }
  }

  Widget _loadingPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF0F0F0),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
          Icon(Icons.people_outline, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No top-rated teachers yet",
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
