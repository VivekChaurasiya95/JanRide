import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/location_model.dart';
import '../../navigation/app_router.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/ride_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LocationModel? _fromStop;
  LocationModel? _toStop;
  String _selectedPreference = 'tez';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homeVm = context.read<HomeViewModel>();
      if (homeVm.stops.isEmpty && !homeVm.isLoading) {
        await homeVm.initialize();
      }
      if (!mounted) {
        return;
      }
      _seedDefaultStops(homeVm.stops);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final stops = homeVm.stops;
    if (_fromStop == null && stops.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _seedDefaultStops(stops);
      });
    }

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
                  hint: _fromStop?.name ?? 'Current Location',
                  onTap: () => _pickStop(isFromStop: true, stops: stops),
                ),
                const SizedBox(height: 12),
                _buildSearchInput(
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  hint: _toStop?.name ?? 'Where to?',
                  onTap: () => _pickStop(isFromStop: false, stops: stops),
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
                _buildPreferenceTab('Sasta', _selectedPreference == 'sasta', () {
                  setState(() => _selectedPreference = 'sasta');
                }),
                const SizedBox(width: 8),
                _buildPreferenceTab('Tez', _selectedPreference == 'tez', () {
                  setState(() => _selectedPreference = 'tez');
                }),
                const SizedBox(width: 8),
                _buildPreferenceTab('Kam Badlav', _selectedPreference == 'kam_badlav', () {
                  setState(() => _selectedPreference = 'kam_badlav');
                }),
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
                _buildRecentSearchItem('Maharaj Bada', 'Gwalior, Madhya Pradesh'),
                _buildRecentSearchItem('Gwalior Fort', 'Gwalior, Madhya Pradesh'),
                _buildRecentSearchItem('Gwalior Railway Station', 'Gwalior, Madhya Pradesh'),
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
                  if (_fromStop == null || _toStop == null || _fromStop!.id == _toStop!.id) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please choose two different locations.')),
                    );
                    return;
                  }

                  Navigator.pushNamed(context, AppRouter.routeResults);
                  final vm = context.read<RideViewModel>();
                  await vm.searchRoutes(
                    fromStopId: _fromStop!.id,
                    toStopId: _toStop!.id,
                    preference: _selectedPreference,
                    fromStopName: _fromStop!.name,
                    toStopName: _toStop!.name,
                  );
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

  void _seedDefaultStops(List<LocationModel> stops) {
    if (stops.isEmpty) {
      return;
    }
    final station = _findStopByName(stops, 'Gwalior Railway Station') ?? stops.first;
    final fort = _findStopByName(stops, 'Gwalior Fort (Man Singh Palace)') ?? (stops.length > 1 ? stops[1] : stops.first);
    setState(() {
      _fromStop ??= station;
      _toStop ??= fort;
      if (_fromStop?.id == _toStop?.id && stops.length > 1) {
        _toStop = stops.firstWhere((stop) => stop.id != _fromStop!.id, orElse: () => fort);
      }
    });
  }

  LocationModel? _findStopByName(List<LocationModel> stops, String name) {
    for (final stop in stops) {
      if (stop.name.toLowerCase() == name.toLowerCase()) {
        return stop;
      }
    }
    return null;
  }

  Future<void> _pickStop({required bool isFromStop, required List<LocationModel> stops}) async {
    var availableStops = stops;
    if (availableStops.isEmpty) {
      final homeVm = context.read<HomeViewModel>();
      if (!homeVm.isLoading) {
        await homeVm.initialize();
      }
      if (!mounted) {
        return;
      }
      availableStops = homeVm.stops;
    }

    if (availableStops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stops are still loading, please wait.')),
      );
      return;
    }

    final selected = await showModalBottomSheet<LocationModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            itemCount: availableStops.length,
            itemBuilder: (context, index) {
              final stop = availableStops[index];
              return ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Color(0xFF2962FF)),
                title: Text(stop.name),
                subtitle: Text(stop.city ?? 'Gwalior'),
                onTap: () => Navigator.pop(context, stop),
              );
            },
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      if (isFromStop) {
        _fromStop = selected;
      } else {
        _toStop = selected;
      }
    });
  }

  Widget _buildSearchInput({required IconData icon, required Color iconColor, required String hint, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    color: hint == 'Where to?' ? Colors.grey : Colors.black,
                    fontWeight: hint == 'Where to?' ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.blueGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceTab(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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


