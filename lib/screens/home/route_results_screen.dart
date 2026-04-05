import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ride_model.dart';
import '../../navigation/app_router.dart';
import '../../viewmodels/ride_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';

class RouteResultsScreen extends StatelessWidget {
  const RouteResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rideVm = context.watch<RideViewModel>();
    final routes = rideVm.routes;
    final isLoading = rideVm.isLoading;
    final errorMessage = rideVm.errorMessage;
    final infoMessage = rideVm.infoMessage;
    final selectedPreference = rideVm.selectedPreference;
    final selectedPreferenceLabel = _preferenceLabel(selectedPreference);
    final fromStopName = rideVm.selectedFromStopName;
    final toStopName = rideVm.selectedToStopName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Results',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              fromStopName != null && toStopName != null
                  ? '$fromStopName to $toStopName'
                  : 'Railway Station to Gwalior Fort',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Keep map in a dedicated widget so provider updates don't recreate platform view state.
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const _RouteMapPane(),
              ),
              const SizedBox(height: 80), // Space for filters
            ],
          ),

          // Filters row
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildFilterChip(Icons.bolt, 'Fastest', selectedPreference == 'tez' || selectedPreference == 'fastest'),
                    const SizedBox(width: 12),
                    _buildFilterChip(Icons.payments_outlined, 'Cheapest', selectedPreference == 'sasta' || selectedPreference == 'cheapest'),
                    const SizedBox(width: 12),
                    _buildFilterChip(Icons.directions_bus_outlined, 'Direct Only', selectedPreference == 'kam_badlav' || selectedPreference == 'fewest_transfers'),
                  ],
                ),
              ),
            ),
          ),

          // Results list
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.45,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildContextCard(
                  selectedPreferenceLabel: selectedPreferenceLabel,
                  fromStopName: fromStopName,
                  toStopName: toStopName,
                ),
                if (infoMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Color(0xFF2962FF)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            infoMessage,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _buildPriceComparisonCard(routes),
                const SizedBox(height: 16),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (routes.isEmpty)
                  _buildEmptyState(errorMessage)
                else
                  ...List<Widget>.generate(routes.length, (index) {
                    final route = routes[index];
                    final firstLeg = route.legs.isNotEmpty ? route.legs.first : null;
                    final title = firstLeg == null ? 'Route ${index + 1}' : '${firstLeg.vehicle} route';
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == routes.length - 1 ? 0 : 16),
                      child: _buildRouteCard(
                        context,
                        title: title,
                        traffic: route.recommendationReason,
                        price: '₹${route.totalFare.toStringAsFixed(0)}',
                        time: '${route.totalTimeMinutes} mins • ${route.totalDistanceKm.toStringAsFixed(2)} km',
                        isRecommended: index == 0,
                        icon: Icons.alt_route,
                        footer: '${route.transfers} Transfers • ${route.path.join(' -> ')}',
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.search),
    );
  }

  String _preferenceLabel(String preference) {
    switch (preference) {
      case 'sasta':
      case 'cheapest':
        return 'Sasta';
      case 'kam_badlav':
      case 'fewest_transfers':
        return 'Kam Badlav';
      case 'tez':
      case 'fastest':
      default:
        return 'Tez';
    }
  }

  Widget _buildContextCard({
    required String selectedPreferenceLabel,
    required String? fromStopName,
    required String? toStopName,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.route, color: Color(0xFF2962FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${fromStopName ?? 'From'} -> ${toStopName ?? 'To'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2962FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              selectedPreferenceLabel,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceComparisonCard(List<RideModel> routes) {
    final comparison = _buildPriceComparison(routes);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildFarePill('Auto', comparison['auto']!)),
              const SizedBox(width: 8),
              Expanded(child: _buildFarePill('Shared Tempo', comparison['shared_tempo']!)),
              const SizedBox(width: 8),
              Expanded(child: _buildFarePill('E-Rickshaw', comparison['e_rickshaw']!)),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, double> _buildPriceComparison(List<RideModel> routes) {
    final prices = <String, double?>{'auto': null, 'shared_tempo': null, 'e_rickshaw': null};
    for (final route in routes) {
      final vehicle = route.legs.isNotEmpty ? route.legs.first.vehicle.toLowerCase() : '';
      String? key;
      if (vehicle.contains('e-rickshaw')) {
        key = 'e_rickshaw';
      } else if (vehicle.contains('auto')) {
        key = 'auto';
      } else if (vehicle.contains('tempo') || vehicle.contains('magic')) {
        key = 'shared_tempo';
      }
      if (key == null) {
        continue;
      }
      final existing = prices[key];
      if (existing == null || route.totalFare < existing) {
        prices[key] = route.totalFare;
      }
    }

    final baseDistance = routes.isNotEmpty && routes.first.totalDistanceKm > 0 ? routes.first.totalDistanceKm : 3.0;
    final output = <String, double>{
      'auto': prices['auto'] ?? _estimateFare(baseDistance, perKm: 12, baseFare: 20, minFare: 45),
      'shared_tempo': prices['shared_tempo'] ?? _estimateFare(baseDistance, perKm: 5, baseFare: 8, minFare: 15),
      'e_rickshaw': prices['e_rickshaw'] ?? _estimateFare(baseDistance, perKm: 8, baseFare: 12, minFare: 30),
    };
    return output;
  }

  double _estimateFare(double distanceKm, {required double perKm, required double baseFare, required double minFare}) {
    final fare = baseFare + (distanceKm * perKm);
    return fare < minFare ? minFare : fare.roundToDouble();
  }

  Widget _buildFarePill(String label, double fare) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          const SizedBox(height: 2),
          Text(
            'Rs ${fare.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2962FF)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String? errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        errorMessage ?? 'No route found for this location pair. Try switching preference.',
        style: const TextStyle(color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2962FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF2962FF) : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(
    BuildContext context, {
    required String title,
    required String traffic,
    required String price,
    required String time,
    required bool isRecommended,
    required IconData icon,
    required String footer,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.bookingStatus);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRecommended ? const Color(0xFF2962FF) : Colors.grey.shade200,
            width: isRecommended ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            if (isRecommended)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2962FF),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5FF), borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: const Color(0xFF2962FF)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            const Icon(Icons.trending_up, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                traffic,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF2962FF))),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, _) {
                  final segments = footer.split('•');
                  final left = segments.isNotEmpty ? segments.first.trim() : footer;
                  final right = segments.length > 1 ? segments[1].trim() : '';
                  return Row(
                    children: [
                      const Icon(Icons.sync, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      if (right.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMapPane extends StatefulWidget {
  const _RouteMapPane();

  @override
  State<_RouteMapPane> createState() => _RouteMapPaneState();
}

class _RouteMapPaneState extends State<_RouteMapPane> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.asset(
        'assets/images/permission_map.png',
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
