import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _messageNotifications = true;
  String _language = 'English';
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        children: [
          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive app notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive email updates',
            value: _emailNotifications,
            enabled: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
            },
          ),
          _buildSwitchTile(
            title: 'Message Notifications',
            subtitle: 'Get notified about new messages',
            value: _messageNotifications,
            enabled: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _messageNotifications = value);
            },
          ),
          Divider(),
          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildLanguageSelector(),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
            },
          ),
          Divider(),
          // Account Section
          _buildSectionHeader('Account'),
          _buildTile(
            title: 'Privacy Settings',
            subtitle: 'Control who can see your profile',
            icon: Icons.privacy_tip,
          ),
          _buildTile(
            title: 'Blocked Users',
            subtitle: 'Manage blocked users',
            icon: Icons.block,
          ),
          _buildTile(
            title: 'Change Password',
            subtitle: 'Update your password',
            icon: Icons.lock,
          ),
          Divider(),
          // About Section
          _buildSectionHeader('About'),
          _buildTile(
            title: 'Version',
            subtitle: 'App version 1.0.0',
            icon: Icons.info,
          ),
          _buildTile(
            title: 'Terms of Service',
            subtitle: 'Read our terms',
            icon: Icons.description,
          ),
          _buildTile(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            icon: Icons.policy,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: Colors.blue,
    );
  }

  Widget _buildTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle navigation
      },
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: Icon(Icons.language, color: Colors.blue),
      title: Text('Language'),
      subtitle: Text('Choose app language'),
      trailing: DropdownButton<String>(
        value: _language,
        items: ['English', 'Bengali', 'Spanish'].map((lang) {
          return DropdownMenuItem(value: lang, child: Text(lang));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _language = value);
          }
        },
      ),
    );
  }
}
