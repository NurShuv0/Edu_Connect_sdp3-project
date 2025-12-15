import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_app/src/core/services/auth_service.dart';
import 'package:test_app/src/core/services/storage_service.dart';
import 'package:test_app/src/config/api_config.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_stats_card.dart';
import 'widgets/admin_users_table.dart';
import 'widgets/admin_sidebar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  final authService = GetIt.I<AuthService>();
  final storageService = GetIt.I<StorageService>();
  late TabController _tabController;
  late Future<Map<String, dynamic>> dashboardStats;
  late Future<List<Map<String, dynamic>>> usersList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    dashboardStats = _fetchDashboardStats();
    usersList = _fetchUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchDashboardStats() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/dashboard/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? {};
      }
      return {};
    } catch (e) {
      print('Error fetching stats: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/users?limit=50'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List users = data['data'] ?? [];
        return users.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPendingProfiles() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/profiles/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List profiles = data['data'] ?? [];
        return profiles.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching pending profiles: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPendingTuitionPosts() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/tuition-posts/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List posts = data['data'] ?? [];
        return posts.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching pending posts: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPendingNIDs() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/nid/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List nids = data['data'] ?? [];
        return nids.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching pending NIDs: $e');
      return [];
    }
  }

  Future<void> _approveProfile(String userId) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/profiles/$userId/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile approved successfully')),
        );
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error approving profile: $e');
    }
  }

  Future<void> _rejectProfile(String userId, String reason) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/profiles/$userId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile rejected')));
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error rejecting profile: $e');
    }
  }

  Future<void> _approveTuitionPost(String postId) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/admin/tuition-posts/$postId/approve',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tuition post approved')));
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error approving post: $e');
    }
  }

  Future<void> _rejectTuitionPost(String postId, String reason) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/admin/tuition-posts/$postId/reject',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tuition post rejected')));
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error rejecting post: $e');
    }
  }

  Future<void> _verifyNID(String nidId) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/nid/$nidId/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NID verified successfully')),
        );
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error verifying NID: $e');
    }
  }

  Future<void> _banUser(String userId, String reason) async {
    try {
      final token = await storageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/users/$userId/ban'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User banned successfully')),
        );
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error banning user: $e');
    }
  }

  Future<void> _createNotice(
    String title,
    String content,
    String priority,
  ) async {
    try {
      final token = await storageService.getToken();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/notices'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'priority': priority,
          'targetRole': 'all',
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notice created successfully')),
        );
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error creating notice: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: Row(
        children: [
          // Sidebar
          if (!isSmallScreen)
            SizedBox(width: 280, child: AdminSidebar(onLogout: _handleLogout)),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                AdminHeader(onLogout: _handleLogout),
                // Tab Bar
                Container(
                  color: const Color(0xFF1A1F26),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: const Color(0xFF00D4FF),
                    labelColor: const Color(0xFF00D4FF),
                    unselectedLabelColor: Colors.white54,
                    tabs: const [
                      Tab(
                        child: Text('Overview', style: TextStyle(fontSize: 14)),
                      ),
                      Tab(
                        child: Text(
                          'Profile Approvals',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Tuition Posts',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'NID Verification',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'User Bans',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text('Notices', style: TextStyle(fontSize: 14)),
                      ),
                      Tab(child: Text('Users', style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
                // Tab View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildProfileApprovalsTab(),
                      _buildTuitionPostsTab(),
                      _buildNIDVerificationTab(),
                      _buildUserBansTab(),
                      _buildNoticesTab(),
                      _buildUsersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          FutureBuilder<Map<String, dynamic>>(
            future: dashboardStats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final stats = snapshot.data ?? {};
              final users = stats['users'] as Map<String, dynamic>? ?? {};
              final tuitions = stats['tuitions'] as Map<String, dynamic>? ?? {};

              return GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AdminStatsCard(
                    icon: Icons.people,
                    title: 'Total Users',
                    value: '${users['totalUsers'] ?? 0}',
                    subtitle: '${users['activeUsers'] ?? 0} active',
                    color: const Color(0xFF00D4FF),
                    delay: 0,
                  ),
                  AdminStatsCard(
                    icon: Icons.school,
                    title: 'Students',
                    value: '${users['students'] ?? 0}',
                    subtitle: '${users['verifiedUsers'] ?? 0} verified',
                    color: const Color(0xFF00D4FF),
                    delay: 100,
                  ),
                  AdminStatsCard(
                    icon: Icons.person_pin,
                    title: 'Teachers',
                    value: '${users['teachers'] ?? 0}',
                    subtitle: 'Active instructors',
                    color: const Color(0xFF00D4FF),
                    delay: 200,
                  ),
                  AdminStatsCard(
                    icon: Icons.book,
                    title: 'Active Tuitions',
                    value: '${tuitions['activeTuitions'] ?? 0}',
                    subtitle: '${tuitions['pendingTuitions'] ?? 0} pending',
                    color: const Color(0xFFFF6B9D),
                    delay: 300,
                  ),
                  AdminStatsCard(
                    icon: Icons.admin_panel_settings,
                    title: 'Admins',
                    value: '${users['admins'] ?? 0}',
                    subtitle: 'Platform admins',
                    color: const Color(0xFF00D4FF),
                    delay: 400,
                  ),
                  AdminStatsCard(
                    icon: Icons.block,
                    title: 'Suspended',
                    value: '${users['suspendedUsers'] ?? 0}',
                    subtitle: 'Blocked accounts',
                    color: const Color(0xFFFF6B9D),
                    delay: 500,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileApprovalsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPendingProfiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No pending profiles',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          );
        }

        final profiles = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return Card(
              color: const Color(0xFF1A1F26),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile['name'] ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              profile['email'] ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Role: ${profile['role'] ?? 'N/A'}',
                              style: const TextStyle(
                                color: Color(0xFF00D4FF),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _approveProfile(profile['_id'] ?? ''),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00D4FF),
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _showRejectDialog(
                                profile['_id'] ?? '',
                                'profile',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B9D),
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTuitionPostsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPendingTuitionPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No pending tuition posts',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          );
        }

        final posts = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              color: const Color(0xFF1A1F26),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'] ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                post['details'] ?? 'No description',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Class: ${post['classLevel'] ?? 'N/A'} | Subjects: ${post['subjects']?.join(', ') ?? 'N/A'}',
                                style: const TextStyle(
                                  color: Color(0xFF00D4FF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _approveTuitionPost(post['_id'] ?? ''),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00D4FF),
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _showRejectDialog(
                                post['_id'] ?? '',
                                'tuition',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B9D),
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNIDVerificationTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPendingNIDs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No pending NID verifications',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          );
        }

        final nids = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: nids.length,
          itemBuilder: (context, index) {
            final nid = nids[index];
            return Card(
              color: const Color(0xFF1A1F26),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NID: ${nid['nidNumber'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Name: ${nid['fullName'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'DOB: ${nid['dateOfBirth'] ?? 'N/A'} | Expires: ${nid['expiryDate'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Color(0xFF00D4FF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _verifyNID(nid['_id'] ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                      ),
                      child: const Text('Verify'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserBansTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No users found',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          );
        }

        final users = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final isBanned = user['isBanned'] ?? false;
            return Card(
              color: const Color(0xFF1A1F26),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['email'] ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                        if (isBanned)
                          Text(
                            'Banned: ${user['banReason'] ?? 'No reason'}',
                            style: const TextStyle(
                              color: Color(0xFFFF6B9D),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showBanDialog(user['_id'] ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBanned
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFFFF6B9D),
                      ),
                      child: Text(isBanned ? 'Unban' : 'Ban User'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoticesTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: _showCreateNoticeDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Notice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Notices',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchNotices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notices',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                final notices = snapshot.data!;
                return ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    final priorityColor = _getPriorityColor(notice['priority']);
                    return Card(
                      color: const Color(0xFF1A1F26),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notice['title'] ?? 'N/A',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        notice['content'] ?? 'N/A',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    notice['priority'] ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: usersList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return AdminUsersTable(
                  users: snapshot.data ?? [],
                  onRefresh: () {
                    setState(() {
                      usersList = _fetchUsers();
                      dashboardStats = _fetchDashboardStats();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchNotices() async {
    try {
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/notices'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List notices = data['data'] ?? [];
        return notices.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching notices: $e');
      return [];
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'critical':
        return const Color(0xFFFF6B6B);
      case 'high':
        return const Color(0xFFFF6B9D);
      case 'medium':
        return const Color(0xFF00D4FF);
      default:
        return const Color(0xFF888888);
    }
  }

  void _showRejectDialog(String id, String type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        title: Text(
          'Reject ${type == 'profile' ? 'Profile' : 'Post'}',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Reason for rejection',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00D4FF)),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (type == 'profile') {
                _rejectProfile(id, controller.text);
              } else {
                _rejectTuitionPost(id, controller.text);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showBanDialog(String userId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        title: const Text('Ban User', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Reason for ban',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00D4FF)),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _banUser(userId, controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
            ),
            child: const Text('Ban'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showCreateNoticeDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        title: const Text(
          'Create Notice',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Notice Title',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF00D4FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Notice Content',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF00D4FF)),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedPriority,
                  dropdownColor: const Color(0xFF1A1F26),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value ?? 'medium';
                    });
                  },
                  items: ['low', 'medium', 'high', 'critical']
                      .map(
                        (priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _createNotice(
                titleController.text,
                contentController.text,
                selectedPriority,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4FF),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    ).then((_) {
      titleController.dispose();
      contentController.dispose();
    });
  }

  void _handleLogout() {
    authService.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
