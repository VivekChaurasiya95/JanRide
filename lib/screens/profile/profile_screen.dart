import 'package:flutter/material.dart';

import '../../navigation/app_router.dart';
import '../../utils/app_images.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile / प्रोफाइल',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        AppImages.profileAvatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRouter.editProfile),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2962FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Amit Sharma',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A)),
            ),
            const Text(
              '+91 98765 43210',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 24),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('JANPASS', 'Active', Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('WALLET', '₹420.00', Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Activity Section
            _buildSectionHeader('MY ACTIVITY / मेरी गतिविधि'),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Ride History',
              subtitle: 'यात्रा इतिहास',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.routeResults),
            ),
            _buildMenuItem(
              icon: Icons.bookmark_outline,
              title: 'Saved Routes',
              subtitle: 'पसंदीदा मार्ग',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.search),
            ),
            const SizedBox(height: 24),
            // Settings Section
            _buildSectionHeader('SETTINGS / सेटिंग्स'),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'सेटिंग्स',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.profileSettings),
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: 'App Language',
              subtitle: 'ऐप की भाषा',
              trailing: 'English / Hindi',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.language),
            ),
            _buildMenuItem(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'सूचनाएं',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.alerts),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'मदद और सहायता',
              iconColor: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRouter.profileHelp),
            ),
            const SizedBox(height: 32),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFFFFEBEE)),
                  backgroundColor: const Color(0xFFFFFBFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      'Logout / लॉग आउट',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'JANRIDE V2.4.0 (BETA)',
              style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.profile),
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A)),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing,
                    style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w500),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
