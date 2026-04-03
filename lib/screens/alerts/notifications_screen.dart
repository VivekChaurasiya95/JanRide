import 'package:flutter/material.dart';
import '../../navigation/app_router.dart';
import '../../widgets/bottom_nav_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Mark all as read', style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold)),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF2962FF),
            labelColor: Color(0xFF2962FF),
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Unread'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('Live Alerts', true, Icons.tune),
                  const SizedBox(width: 8),
                  _buildFilterChip('Route Updates', false, null),
                  const SizedBox(width: 8),
                  _buildFilterChip('System', false, null),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('RECENT UPDATES', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    title: 'Heavy Crowd at Gwalior Fort',
                    subtitle: 'Gwalior Fort par bheed hai',
                    time: '2 MINS AGO',
                    tag: 'LIVE ALERT',
                    tagColor: Colors.orange,
                    icon: Icons.people,
                    iconBg: const Color(0xFFFFF7ED),
                    isUnread: true,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    title: 'Route 104 Delayed by 15 mins',
                    subtitle: 'Route 104 mein 15 min ki deri hai',
                    time: '15 MINS AGO',
                    tag: 'ROUTE UPDATE',
                    tagColor: const Color(0xFF2962FF),
                    icon: Icons.directions_bus,
                    iconBg: const Color(0xFFEAF2FF),
                    isUnread: true,
                  ),
                  const SizedBox(height: 24),
                  const Text('YESTERDAY', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    title: 'Wallet Recharge Successful',
                    subtitle: 'Wallet recharge safal raha',
                    time: '1 DAY AGO',
                    tag: 'SYSTEM',
                    tagColor: Colors.grey,
                    icon: Icons.account_balance_wallet,
                    iconBg: const Color(0xFFF1F5F9),
                    isUnread: false,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    title: 'New Metro Line Operational',
                    subtitle: 'Nayi Metro Line shuru ho gayi hai',
                    time: '1 DAY AGO',
                    tag: 'ROUTE UPDATE',
                    tagColor: const Color(0xFF2962FF),
                    icon: Icons.train,
                    iconBg: const Color(0xFFEAF2FF),
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.notifications),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2962FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF2962FF) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.blueGrey), const SizedBox(width: 6)],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required String tag,
    required Color tagColor,
    required IconData icon,
    required Color iconBg,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: tagColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D1B2A)))),
                    if (isUnread) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2962FF), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
