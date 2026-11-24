import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../services/auth_service.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _remindersEnabled = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      // Clear the saved authentication token.
      await AuthService.logout();

      if (!mounted) return;

      // Return to Splash Screen and clear previous screens.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage('Logout failed: $e');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Account Settings
            _buildSectionTitle('Account Settings'),

            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Manage your personal information',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () {
                _showMessage(
                  'Password change will be connected to the backend.',
                );
              },
            ),

            // Notification Settings
            _buildSectionTitle('Notifications'),

            Card(
              color: Colors.white,
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Push Notifications'),
                subtitle: const Text('Enable or disable notifications'),
                value: _notificationsEnabled,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.white,
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.alarm_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Health Reminders'),
                subtitle: const Text('Receive health tracking reminders'),
                value: _remindersEnabled,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _remindersEnabled = value;
                  });
                },
              ),
            ),

            // Privacy Settings
            _buildSectionTitle('Privacy & Security'),

            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Learn how your information is handled',
              onTap: () {
                _showMessage('Privacy policy page will be added later.');
              },
            ),

            _buildSettingsTile(
              icon: Icons.security_outlined,
              title: 'Data Security',
              subtitle: 'Information about account protection',
              onTap: () {
                _showMessage('Security features will be connected later.');
              },
            ),

            // About
            _buildSectionTitle('About'),

            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About EndoSense-AI',
              subtitle: 'Learn more about our application',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'EndoSense-AI',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Preliminary hormonal and metabolic health awareness application.',
                );
              },
            ),

            const SizedBox(height: 25),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'EndoSense-AI | Version 1.0.0',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
