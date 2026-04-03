import 'package:flutter/material.dart';

import '../../navigation/app_router.dart';
import '../../widgets/bottom_nav_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Live Alerts',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAlertCard(
            'Heavy Crowd at Gwalior Fort',
            'Commuters reporting a 20 min wait time for autos.',
            Icons.warning_amber_rounded,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildAlertCard(
            'New Route Available',
            'A faster E-Rickshaw route is now active near Phoolbagh.',
            Icons.info_outline,
            Colors.blue,
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.support),
    );
  }

  Widget _buildAlertCard(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
