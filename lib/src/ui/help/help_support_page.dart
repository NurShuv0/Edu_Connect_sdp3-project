import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), elevation: 0),
      body: ListView(
        children: [
          _buildSectionHeader('FAQ', Icons.help),
          _buildFaqItem(
            'How do I post a tuition request?',
            'Go to the dashboard, click "Post Tuition", fill in your requirements including subject, class level, location, and budget. Your post will be reviewed by admin before being published.',
          ),
          _buildFaqItem(
            'How do I apply for a tuition?',
            'Browse available tuitions in the marketplace, click on one that interests you, and click the "Apply" button. The student will review your application.',
          ),
          _buildFaqItem(
            'How do I accept/reject applications?',
            'In your tuition details, you\'ll see all applications. Click "Accept" to proceed with a teacher or "Reject" with an optional reason.',
          ),
          _buildFaqItem(
            'How do I get paid?',
            'Payments are processed through our secure payment system. You can withdraw your earnings to your bank account from the wallet section.',
          ),
          Divider(),
          _buildSectionHeader('Contact Us', Icons.phone),
          _buildContactTile(
            icon: Icons.email,
            label: 'Email',
            value: 'support@educonnect.com',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email copied to clipboard')),
              );
            },
          ),
          _buildContactTile(
            icon: Icons.phone,
            label: 'Phone',
            value: '+880 1234-567890',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Phone copied to clipboard')),
              );
            },
          ),
          _buildContactTile(
            icon: Icons.location_on,
            label: 'Address',
            value: 'Dhaka, Bangladesh',
            onTap: () {},
          ),
          Divider(),
          _buildSectionHeader('Resources', Icons.book),
          _buildResourceTile(
            title: 'User Guide',
            description: 'Complete guide to using EduConnect',
          ),
          _buildResourceTile(
            title: 'Safety Tips',
            description: 'Learn how to stay safe on our platform',
          ),
          _buildResourceTile(
            title: 'Pricing Information',
            description: 'Understand our commission and fees',
          ),
          Divider(),
          _buildSectionHeader('Community', Icons.people),
          _buildCommunityTile(
            icon: Icons.forum,
            title: 'Community Forum',
            description: 'Join discussions with other users',
          ),
          _buildCommunityTile(
            icon: Icons.video_library,
            title: 'Video Tutorials',
            description: 'Watch step-by-step tutorials',
          ),
          _buildCommunityTile(
            icon: Icons.feedback,
            title: 'Send Feedback',
            description: 'Help us improve the app',
            onTap: () {
              _showFeedbackDialog(context);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData(useMaterial3: true),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
      trailing: Icon(Icons.content_copy, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildResourceTile({
    required String title,
    required String description,
  }) {
    return ListTile(
      leading: Icon(Icons.article, color: Colors.blue),
      title: Text(title),
      subtitle: Text(description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to resource
      },
    );
  }

  Widget _buildCommunityTile({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          minLines: 3,
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
