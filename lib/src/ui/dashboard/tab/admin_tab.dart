import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/admin_service.dart';
import 'package:test_app/src/core/utils/snackbar_utils.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  final admin = GetIt.instance<AdminService>();

  bool loading = true;

  Map<String, dynamic>? stats;
  List<dynamic> users = [];
  List<dynamic> tuitions = [];
  List<dynamic> teachers = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    try {
      // Load each section independently so one failure doesn't block others
      try {
        stats = await admin.getStats();
      } catch (e) {
        print("Error loading stats: $e");
        stats = null;
      }

      try {
        users = await admin.getUsers();
      } catch (e) {
        print("Error loading users: $e");
        users = [];
      }

      try {
        teachers = await admin.getTeachersPending();
      } catch (e) {
        print("Error loading pending teachers: $e");
        teachers = [];
      }

      try {
        tuitions = await admin.getTuitionsPending();
      } catch (e) {
        print("Error loading pending tuitions: $e");
        tuitions = [];
      }
    } catch (e) {
      print("Unexpected error in loadData: $e");
      // Don't show snackbar - individual calls handle their own errors
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //===============================
            // PLATFORM OVERVIEW CARD
            //===============================
            _platformOverviewCard(),

            const SizedBox(height: 24),

            //===============================
            // KEY METRICS (3 cards)
            //===============================
            _keyMetricsRow(),

            const SizedBox(height: 30),

            //===============================
            // RECENT USERS TABLE
            //===============================
            _recentUsersSection(),

            const SizedBox(height: 30),

            //===============================
            // DEMO REQUESTS SECTION
            //===============================
            _demoRequestsSection(),

            const SizedBox(height: 30),

            //===============================
            // TEACHER & TUITION APPROVALS
            //===============================
            if (teachers.isNotEmpty) ...[
              _sectionTitle("🎓 Teacher Approvals"),
              _teacherApprovalList(),
              const SizedBox(height: 30),
            ],

            if (tuitions.isNotEmpty) ...[
              _sectionTitle("📘 Tuition Approvals"),
              _tuitionApprovalList(),
            ],
          ],
        ),
      ),
    );
  }

  //===========================================================
  // SECTION TITLE
  //===========================================================
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.indigo,
      ),
    ),
  );

  //===========================================================
  // PLATFORM OVERVIEW CARD
  //===========================================================
  Widget _platformOverviewCard() {
    final totalUsers = stats?["totalUsers"] ?? 0;
    final students = stats?["students"] ?? 0;
    final teachers = stats?["teachers"] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Platform Overview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "$totalUsers users • $students students • $teachers teachers",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //===========================================================
  // KEY METRICS ROW (3 cards)
  //===========================================================
  Widget _keyMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            icon: Icons.school,
            title: "Active Tuitions",
            value: "${stats?["activeTuitions"] ?? 0}",
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.pending_actions,
            title: "Pending Approvals",
            value: "${(stats?["pendingTuitions"] ?? 0) + teachers.length}",
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.video_call,
            title: "Demo Requests",
            value: "${stats?["demoRequests"] ?? 0}",
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  //===========================================================
  // RECENT USERS SECTION (TABLE)
  //===========================================================
  Widget _recentUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Users",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "User",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Role",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Rows
              ...users.take(6).map((u) {
                final suspended = u["isSuspended"] == true;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              u["name"] ?? "Unknown",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              u["email"] ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          u["role"] ?? "user",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          suspended ? "Suspended" : "Active",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: suspended ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  //===========================================================
  // DEMO REQUESTS SECTION
  //===========================================================
  Widget _demoRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Demo Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "No demo requests yet.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  //===========================================================
  // TEACHER APPROVAL LIST
  //===========================================================
  Widget _teacherApprovalList() {
    if (teachers.isEmpty) {
      return const Text(
        "No pending teacher verifications",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: teachers.map((t) {
        return Card(
          child: ListTile(
            title: Text(t["fullName"] ?? "Unknown"),
            subtitle: Text("Department: ${t["department"]}"),
            trailing: ElevatedButton(
              onPressed: () async {
                await admin.approveTeacher(t["userId"]);
                loadData();
              },
              child: const Text("Approve"),
            ),
          ),
        );
      }).toList(),
    );
  }

  //===========================================================
  // TUITION APPROVAL LIST
  //===========================================================
  Widget _tuitionApprovalList() {
    if (tuitions.isEmpty) {
      return const Text(
        "No pending tuition posts",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: tuitions.map((post) {
        return Card(
          child: ListTile(
            title: Text(post["subject"]),
            subtitle: Text("${post["city"]}, ${post["classLevel"]}"),
            trailing: ElevatedButton(
              onPressed: () async {
                await admin.approveTuition(post["_id"]);
                loadData();
              },
              child: const Text("Approve"),
            ),
          ),
        );
      }).toList(),
    );
  }
}
