import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/src/core/services/auth_service.dart';

class AdminHeader extends StatefulWidget {
  final VoidCallback onLogout;

  const AdminHeader({Key? key, required this.onLogout}) : super(key: key);

  @override
  State<AdminHeader> createState() => _AdminHeaderState();
}

class _AdminHeaderState extends State<AdminHeader> {
  final authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    final userName = authService.user?.name ?? 'Admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xCC1A2332), const Color(0xE60F1419)],
        ),
        border: Border(
          bottom: BorderSide(color: const Color(0x3300D4FF), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back, $userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Platform Administration',
                style: TextStyle(color: const Color(0x99FFFFFF), fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIconButton(
                icon: Icons.notifications,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(icon: Icons.settings, onPressed: () {}),
              const SizedBox(width: 12),
              _buildLogoutButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x3300D4FF)),
          ),
          child: Icon(icon, color: const Color(0xFF00D4FF), size: 20),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onLogout,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xCCFF6B9D), const Color(0xCCFF1744)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.logout, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
