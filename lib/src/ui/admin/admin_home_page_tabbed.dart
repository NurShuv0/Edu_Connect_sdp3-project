import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/admin_service.dart';
import 'package:test_app/src/core/services/auth_service.dart';
import 'package:test_app/src/core/utils/snackbar_utils.dart';

class AdminHomePageTabbed extends StatefulWidget {
  const AdminHomePageTabbed({super.key});

  @override
  State<AdminHomePageTabbed> createState() => _AdminHomePageTabbedState();
}

class _AdminHomePageTabbedState extends State<AdminHomePageTabbed>
    with TickerProviderStateMixin {
  final admin = GetIt.instance<AdminService>();
  final auth = GetIt.instance<AuthService>();

  bool loading = true;
  Map<String, dynamic>? stats;
  List<dynamic> users = [];
  List<dynamic> pendingUsers = [];
  List<dynamic> approvedUsers = [];
  List<dynamic> tuitions = [];
  List<dynamic> teachers = [];
  List<dynamic> applications = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    // Load each API independently so one failure doesn't crash everything
    try {
      stats = await admin.getStats();
    } catch (e) {
      print("Error fetching stats: $e");
      stats = {};
    }

    try {
      users = await admin.getUsers();

      // Separate users into pending and approved based on profile approval status
      pendingUsers = users
          .where((u) => u['isProfileApproved'] != true)
          .toList();
      approvedUsers = users
          .where((u) => u['isProfileApproved'] == true)
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      users = [];
      pendingUsers = [];
      approvedUsers = [];
    }

    try {
      teachers = await admin.getTeachersPending();
    } catch (e) {
      print("Error fetching pending teachers: $e");
      teachers = [];
    }

    try {
      tuitions = await admin.getTuitionsPending();
    } catch (e) {
      print("Error fetching pending tuitions: $e");
      tuitions = [];
    }

    try {
      applications = await admin.getApplicationsPending();
    } catch (e) {
      print("Error fetching pending applications: $e");
      applications = [];
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.indigo,
                    labelColor: Colors.indigo,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Overview"),
                      Tab(text: "Users"),
                      Tab(text: "Announcements"),
                      Tab(text: "Messages"),
                      Tab(text: "Approvals"),
                    ],
                  ),
                ),
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Overview Tab
                      _overviewTab(),
                      // Users Tab
                      _usersTab(),
                      // Announcements Tab
                      _announcementsTab(),
                      // Messages Tab
                      _messagesTab(),
                      // Approvals Tab
                      _approvalsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  //===========================================================
  // APP BAR
  //===========================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Admin Dashboard",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              auth.user?.email ?? "Admin",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        PopupMenuButton<String>(
          itemBuilder: (_) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'reload',
              child: const Row(
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 12),
                  Text('Reload'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'settings',
              child: const Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'help',
              child: const Row(
                children: [
                  Icon(Icons.help, size: 20),
                  SizedBox(width: 12),
                  Text('Help'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'about',
              child: const Row(
                children: [
                  Icon(Icons.info, size: 20),
                  SizedBox(width: 12),
                  Text('About'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'reload') {
              loadData();
              showSnackBar(context, 'Dashboard refreshed');
            } else if (value == 'settings') {
              showSnackBar(context, 'Settings coming soon');
            } else if (value == 'help') {
              showSnackBar(context, 'Help coming soon');
            } else if (value == 'about') {
              _showAboutDialog();
            } else if (value == 'logout') {
              _logout();
            }
          },
          icon: const Icon(Icons.more_vert),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About EduConnect'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EduConnect Admin Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 12),
              Text('Manage and oversee all platform activities.'),
              SizedBox(height: 12),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Developed with ❤️ for education',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  //===========================================================
  // OVERVIEW TAB
  //===========================================================
  Widget _overviewTab() {
    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeSection(),
            const SizedBox(height: 32),
            _platformOverviewCard(),
            const SizedBox(height: 28),
            _keyMetricsRow(),
            const SizedBox(height: 32),
            _recentUsersSection(),
            const SizedBox(height: 32),
            _demoRequestsSection(),
          ],
        ),
      ),
    );
  }

  //===========================================================
  // USERS TAB - Full User List with Management
  //===========================================================
  Widget _usersTab() {
    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Users",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _usersManagementTable(),
          ],
        ),
      ),
    );
  }

  Widget _usersManagementTable() {
    if (users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text("No users found")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PENDING APPROVALS SECTION
        if (pendingUsers.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pending Profile Approval",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      Text(
                        "${pendingUsers.length} user(s) need profile approval",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildUserTable(pendingUsers, showApprovalButtons: true),
          const SizedBox(height: 32),
        ],

        // APPROVED USERS SECTION
        if (approvedUsers.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Approved Users",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      Text(
                        "${approvedUsers.length} user(s) approved",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildUserTable(approvedUsers, showApprovalButtons: false),
        ],
      ],
    );
  }

  Widget _buildUserTable(
    List<dynamic> userList, {
    bool showApprovalButtons = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text("Name")),
            const DataColumn(label: Text("Email")),
            const DataColumn(label: Text("Role")),
            const DataColumn(label: Text("Status")),
            if (showApprovalButtons) const DataColumn(label: Text("Actions")),
          ],
          rows: userList.map((u) {
            final suspended = u["isSuspended"] == true;
            return DataRow(
              cells: [
                DataCell(Text(u["name"] ?? "Unknown")),
                DataCell(Text(u["email"] ?? "")),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      u["role"] ?? "user",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: suspended
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      suspended ? "Suspended" : "Active",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: suspended
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
                if (showApprovalButtons)
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await admin.approveUserProfile(u["_id"]);
                              loadData();
                              showSnackBar(
                                context,
                                "User profile approved successfully",
                              );
                            } catch (e) {
                              showSnackBar(context, "Error: $e", isError: true);
                            }
                          },
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text("Approve"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await admin.toggleSuspend(u["_id"]);
                              loadData();
                              showSnackBar(context, "User suspended");
                            } catch (e) {
                              showSnackBar(context, "Error: $e", isError: true);
                            }
                          },
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text("Suspend"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  //===========================================================
  // ANNOUNCEMENTS TAB
  //===========================================================
  Widget _announcementsTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedPriority = "medium";

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Send Announcement to All Users",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.04 * 255).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Title",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Announcement title...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Content
                    const Text(
                      "Content",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: contentController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: "Announcement content...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Priority
                    const Text(
                      "Priority",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPriority,
                      items: ["low", "medium", "high"]
                          .map(
                            (p) => DropdownMenuItem<String>(
                              value: p,
                              child: Text(p.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedPriority = value ?? "medium");
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (titleController.text.isEmpty ||
                              contentController.text.isEmpty) {
                            showSnackBar(
                              context,
                              "Please fill all fields",
                              isError: true,
                            );
                            return;
                          }

                          try {
                            await admin.sendAnnouncement(
                              title: titleController.text,
                              content: contentController.text,
                              priority: selectedPriority,
                            );
                            showSnackBar(
                              context,
                              "Announcement sent successfully",
                            );
                            titleController.clear();
                            contentController.clear();
                          } catch (e) {
                            showSnackBar(context, "Error: $e", isError: true);
                          }
                        },
                        icon: const Icon(Icons.send),
                        label: const Text("Send Announcement"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //===========================================================
  // MESSAGES TAB - Send Direct Messages
  //===========================================================
  Widget _messagesTab() {
    final messageController = TextEditingController();
    String? selectedUserId;

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Send Message to Specific User",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.04 * 255).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Selection
                    const Text(
                      "Select User",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedUserId,
                      items: users
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u["_id"] as String,
                              child: Text("${u["name"]} (${u["email"]})"),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedUserId = value);
                      },
                      decoration: InputDecoration(
                        hintText: "Choose a user...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Message
                    const Text(
                      "Message",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: "Your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (selectedUserId == null ||
                              messageController.text.isEmpty) {
                            showSnackBar(
                              context,
                              "Please select user and enter message",
                              isError: true,
                            );
                            return;
                          }

                          try {
                            await admin.sendMessageToUser(
                              userId: selectedUserId!,
                              message: messageController.text,
                            );
                            showSnackBar(context, "Message sent successfully");
                            messageController.clear();
                            setState(() => selectedUserId = null);
                          } catch (e) {
                            showSnackBar(context, "Error: $e", isError: true);
                          }
                        },
                        icon: const Icon(Icons.message),
                        label: const Text("Send Message"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //===========================================================
  // APPROVALS TAB
  //===========================================================
  Widget _approvalsTab() {
    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pending Approvals",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Teacher Approvals
            if (teachers.isNotEmpty) ...[
              const Text(
                "Teacher Verifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              _teacherApprovalsCard(),
              const SizedBox(height: 32),
            ],

            // Tuition Post Approvals
            if (tuitions.isNotEmpty) ...[
              const Text(
                "Tuition Posts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              _tuitionApprovalsCard(),
              const SizedBox(height: 32),
            ],

            // Tuition Applications Approvals
            if (applications.isNotEmpty) ...[
              const Text(
                "Tuition Applications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              _applicationsApprovalsCard(),
            ],

            if (teachers.isEmpty && tuitions.isEmpty && applications.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("No pending approvals")),
              ),
          ],
        ),
      ),
    );
  }

  Widget _teacherApprovalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: teachers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final t = teachers[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t["name"] ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        t["email"] ?? "",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await admin.approveTeacher(t["_id"] ?? t["userId"]);
                      loadData();
                      showSnackBar(context, "Teacher approved successfully");
                    } catch (e) {
                      showSnackBar(context, "Error: $e", isError: true);
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tuitionApprovalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tuitions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final t = tuitions[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t["title"] ?? "Unknown Tuition",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${t["location"]?["city"] ?? "Location TBD"}, Class ${t["classLevel"] ?? "Unknown"}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await admin.approveTuition(t["_id"]);
                      loadData();
                      showSnackBar(context, "Tuition approved successfully");
                    } catch (e) {
                      showSnackBar(context, "Error: $e", isError: true);
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _applicationsApprovalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: applications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final app = applications[index];
          final post = app['postId'] as Map?;
          final teacher = app['teacherId'] as Map?;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post?['title'] ?? "Unknown Tuition",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Applied by: ${teacher?['name'] ?? 'Unknown Teacher'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Class: ${post?['classLevel'] ?? 'N/A'} | Salary: ${post?['salary'] ?? 'N/A'}",
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await admin.approveApplication(app['_id'] ?? app['id']);
                      loadData();
                      showSnackBar(
                        context,
                        "Application approved successfully",
                      );
                    } catch (e) {
                      showSnackBar(context, "Error: $e", isError: true);
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper methods from original design (kept for reference)
  Widget _welcomeSection() {
    final firstName = (auth.user?.name ?? 'Admin').split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back, $firstName!",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Here's what's happening on your platform today.",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _platformOverviewCard() {
    final totalUsers = stats?["totalUsers"] ?? 0;
    final students = stats?["students"] ?? 0;
    final teachers = stats?["teachers"] ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withAlpha((0.3 * 255).round()),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_customize,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Platform Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
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

  Widget _keyMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            icon: Icons.school_outlined,
            title: "Active Tuitions",
            value: "${stats?["activeTuitions"] ?? 0}",
            color: const Color(0xFF10B981),
            lightColor: const Color(0xFFD1FAE5),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _metricCard(
            icon: Icons.pending_actions_outlined,
            title: "Pending Approvals",
            value: "${(stats?["pendingTuitions"] ?? 0) + teachers.length}",
            color: const Color(0xFFF59E0B),
            lightColor: const Color(0xFFFEF3C7),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _metricCard(
            icon: Icons.video_call_outlined,
            title: "Demo Requests",
            value: "${stats?["demoRequests"] ?? 0}",
            color: const Color(0xFF3B82F6),
            lightColor: const Color(0xFFDBEAFE),
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
    required Color lightColor,
  }) {
    return GestureDetector(
      onTap: title == "Pending Approvals"
          ? () {
              _tabController.animateTo(4); // Navigate to Approvals tab
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.04 * 255).round()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Users",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "View all",
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.04 * 255).round()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ...users.take(6).map((u) {
                final suspended = u["isSuspended"] == true;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  _getInitial(u["name"]),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u["name"] ?? "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    u["email"] ?? "",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            u["role"] ?? "user",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: suspended
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            suspended ? "Suspended" : "Active",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: suspended
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                            textAlign: TextAlign.center,
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

  Widget _demoRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Demo Requests",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.04 * 255).round()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "No demo requests yet.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to safely get first character of name
  String _getInitial(dynamic name) {
    if (name == null || name.toString().isEmpty) {
      return "U";
    }
    return name.toString()[0].toUpperCase();
  }
}
