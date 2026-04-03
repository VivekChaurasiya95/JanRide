import 'package:flutter/material.dart';
import '../../navigation/app_router.dart';
import '../../utils/app_images.dart';
import '../../widgets/bottom_nav_bar.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('WEEKLY ACTIVITY', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                TextButton(onPressed: () {}, child: const Text('View History', style: TextStyle(color: Color(0xFF2962FF)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildActivityCard('Trips Taken', '14', '+20%', Colors.blue),
                const SizedBox(width: 16),
                _buildActivityCard('Money Saved', '\$42.50', '+15%', Colors.blue),
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
                      const Text('Monthly Target: 20kg', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text('12.4', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Text('kg CO2', style: TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Text('62% of limit', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(value: 0.62, minHeight: 8, backgroundColor: Color(0xFFF1F5F9), valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                  ),
                  const SizedBox(height: 16),
                  const Text('You saved 5.6 kg this week by carpooling!', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
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
                  const Text('Refer & Earn \$20', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Invite friends to JanRide and get\ncredits for your next 5 trips.', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
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
                TextButton(onPressed: () {}, child: const Text('Edit', style: TextStyle(color: Color(0xFF2962FF)))),
              ],
            ),
            _buildRouteCard('Home to Office', '12.4 miles • 25 mins avg', '₹40 - ₹60', 'Next Auto in 3 mins', Icons.home),
            const SizedBox(height: 16),
            _buildRouteCard('Gym Session', '3.8 miles • 10 mins avg', '₹15 - ₹25', 'Tempo arriving soon', Icons.fitness_center),
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

  Widget _buildRouteCard(String title, String desc, String fare, String status, IconData icon) {
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2962FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: const Text('Start Trip'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
