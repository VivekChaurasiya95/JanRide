import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../navigation/app_router.dart';
import '../../utils/app_images.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityViewModel>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivityViewModel>();
    final summary = vm.summary;
    final referral = vm.referral;
    final infoMessage = vm.infoMessage;
    final favoriteRoutes = vm.favoriteRoutes.isNotEmpty
        ? vm.favoriteRoutes
        : const <FavoriteRouteModel>[
            FavoriteRouteModel(
              id: 'local_home_office',
              title: 'Home to Office',
              description: '12.4 miles • 25 mins avg',
              fareRange: 'Rs 40 - Rs 60',
              status: 'Next Auto in 3 mins',
              icon: 'home',
            ),
            FavoriteRouteModel(
              id: 'local_gym',
              title: 'Gym Session',
              description: '3.8 miles • 10 mins avg',
              fareRange: 'Rs 15 - Rs 25',
              status: 'Tempo arriving soon',
              icon: 'fitness',
            ),
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFF2962FF), shape: BoxShape.circle),
              child: const Icon(Icons.directions_car, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JanRide', style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Good morning, Alex', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () => Navigator.pushNamed(context, AppRouter.notifications)),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AppImages.profileAvatar),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('WEEKLY ACTIVITY', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.activityHistory),
                  child: const Text('View History', style: TextStyle(color: Color(0xFF2962FF))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildActivityCard(
                  'Trips Taken',
                  '${summary.tripsTaken}',
                  '${summary.tripsChangePercent >= 0 ? '+' : ''}${summary.tripsChangePercent}%',
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildActivityCard(
                  'Money Saved',
                  'Rs ${summary.moneySaved.toStringAsFixed(2)}',
                  '${summary.moneySavedChangePercent >= 0 ? '+' : ''}${summary.moneySavedChangePercent}%',
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle), child: const Icon(Icons.eco, color: Colors.green, size: 20)),
                      const SizedBox(width: 12),
                      const Text('Carbon Footprint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Text('Monthly Target: ${summary.carbonMonthlyTargetKg.toStringAsFixed(0)}kg', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(summary.carbonKg.toStringAsFixed(1), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Text('kg CO2', style: TextStyle(color: Colors.grey)),
                      const Spacer(),
                      Text('${summary.carbonPercentOfLimit}% of limit', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (summary.carbonPercentOfLimit / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('You saved ${summary.carbonWeeklySavedKg.toStringAsFixed(1)} kg this week by carpooling!', style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2962FF),
                borderRadius: BorderRadius.circular(32),
                image: const DecorationImage(
                  image: AssetImage(AppImages.dashboardBanner),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(referral.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(referral.body, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.referEarn),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2962FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                    child: const Text('Invite Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('FAVORITE ROUTES', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.favoriteRoutes),
                  child: const Text('Edit', style: TextStyle(color: Color(0xFF2962FF))),
                ),
              ],
            ),
            ...List<Widget>.generate(favoriteRoutes.length, (index) {
              final route = favoriteRoutes[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index == favoriteRoutes.length - 1 ? 0 : 16),
                child: _buildRouteCard(
                  context,
                  routeId: route.id,
                  title: route.title,
                  desc: route.description,
                  fare: route.fareRange,
                  status: route.status,
                  icon: _iconFromName(route.icon),
                  isStartingTrip: vm.isStartingTrip,
                ),
              );
            }),
            if (infoMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    infoMessage,
                    style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 12),
                  ),
                ),
              ),
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.dashboard),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.search),
        backgroundColor: const Color(0xFF2962FF),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _onStartTrip(BuildContext context, String routeId) async {
    final vm = context.read<ActivityViewModel>();
    final success = await vm.startTrip(routeId);
    if (!context.mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Unable to start trip right now.')),
      );
      return;
    }

    if (vm.infoMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.infoMessage!)),
      );
    }

    Navigator.pushNamed(context, AppRouter.bookingStatus);
  }

  IconData _iconFromName(String icon) {
    switch (icon) {
      case 'home':
        return Icons.home;
      case 'fitness':
        return Icons.fitness_center;
      case 'work':
        return Icons.work;
      default:
        return Icons.route;
    }
  }

  Widget _buildActivityCard(String title, String value, String change, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.swap_vert, color: color, size: 16), const SizedBox(width: 4), Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(change, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(
    BuildContext context, {
    required String routeId,
    required String title,
    required String desc,
    required String fare,
    required String status,
    required IconData icon,
    required bool isStartingTrip,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF1F5FF), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFF2962FF))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                child: Text(fare, style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(child: Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))),
              ElevatedButton(
                onPressed: isStartingTrip ? null : () => _onStartTrip(context, routeId),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2962FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Text(isStartingTrip ? 'Starting...' : 'Start Trip'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
