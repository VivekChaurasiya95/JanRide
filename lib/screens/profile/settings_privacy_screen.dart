import 'package:flutter/material.dart';
import '../../navigation/app_router.dart';
import '../../widgets/bottom_nav_bar.dart';

class SettingsPrivacyScreen extends StatefulWidget {
  const SettingsPrivacyScreen({super.key});

  @override
  State<SettingsPrivacyScreen> createState() => _SettingsPrivacyScreenState();
}

class _SettingsPrivacyScreenState extends State<SettingsPrivacyScreen> {
  bool _isDarkMode = false;
  bool _isBiometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text(
              'Settings & Privacy',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'सेटिंग्स और गोपनीयता',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('APP SETTINGS / ऐप सेटिंग्स'),
            _buildSettingItem(
              icon: Icons.translate,
              title: 'Language / भाषा',
              subtitle: 'English / हिंदी',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('English', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              onTap: () => Navigator.pushNamed(context, AppRouter.language),
            ),
            _buildSettingItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode / डार्क मोड',
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (v) => setState(() => _isDarkMode = v),
                activeThumbColor: const Color(0xFF2962FF),
              ),
            ),
            _buildSettingItem(
              icon: Icons.data_usage,
              title: 'Data Usage / डेटा उपयोग',
              subtitle: 'Low data mode is off',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Standard', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('PRIVACY / गोपनीयता'),
            _buildSettingItem(
              icon: Icons.location_on_outlined,
              title: 'Location Permissions',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, AppRouter.permissions),
            ),
            _buildSettingItem(
              icon: Icons.ads_click,
              title: 'Ad Preferences',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            _buildSettingItem(
              icon: Icons.history,
              title: 'Clear Search History',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('SECURITY / सुरक्षा'),
            _buildSettingItem(
              icon: Icons.security,
              title: 'Two-factor authentication',
              subtitle: 'Enabled',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            _buildSettingItem(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              trailing: Switch(
                value: _isBiometric,
                onChanged: (v) => setState(() => _isBiometric = v),
                activeThumbColor: const Color(0xFF2962FF),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'JanRide v2.4.1 (Build 890)',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.settingsPrivacy),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2962FF),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF2962FF), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12))
            : null,
        trailing: trailing,
      ),
    );
  }
}
