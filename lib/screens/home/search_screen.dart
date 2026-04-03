import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../../viewmodels/ride_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2962FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Plan Your Journey',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSearchInput(
                  icon: Icons.my_location,
                  iconColor: const Color(0xFF2962FF),
                  hint: 'Current Location',
                  isCurrent: true,
                ),
                const SizedBox(height: 12),
                _buildSearchInput(
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  hint: 'Where to?',
                  isCurrent: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ROUTE PREFERENCE',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildPreferenceTab('Sasta', false),
                const SizedBox(width: 8),
                _buildPreferenceTab('Tez', true),
                const SizedBox(width: 8),
                _buildPreferenceTab('Kam Badlav', false),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Clear All', style: TextStyle(color: Color(0xFF2962FF))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildRecentSearchItem('Rajiv Chowk Metro', 'New Delhi, Delhi'),
                _buildRecentSearchItem('Cyber Hub', 'Gurugram, Haryana'),
                _buildRecentSearchItem('Indira Gandhi Airport (T3)', 'New Delhi'),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Saved Places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEAF2FF), Color(0xFFF1F5FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 18, color: Color(0xFF2962FF)),
                          SizedBox(width: 8),
                          Text(
                            'Exploring optimal routes for your city...',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final vm = context.read<RideViewModel>();
                  await vm.searchRoutes(fromStopId: 'S1', toStopId: 'S2', preference: 'fastest');
                  if (!context.mounted) return;

                  if (vm.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vm.errorMessage!)),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, AppRouter.routeResults);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Search Routes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.search),
    );
  }

  Widget _buildSearchInput({required IconData icon, required Color iconColor, required String hint, required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(icon, color: iconColor),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: isCurrent ? Colors.black : Colors.grey, fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildPreferenceTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF1F5FF),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.grey.shade200) : null,
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2962FF) : Colors.blueGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFF1F5FF), shape: BoxShape.circle),
        child: const Icon(Icons.history, color: Colors.blueGrey, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}
