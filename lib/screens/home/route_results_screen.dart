import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../../viewmodels/ride_viewmodel.dart';
import '../../widgets/bottom_nav_bar.dart';

class RouteResultsScreen extends StatelessWidget {
  const RouteResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<RideViewModel>().routes;

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
              routes.isEmpty ? 'Sector 62 to Cyber Hub' : 'Backend route suggestions',
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
              // Map View
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(28.4595, 77.0266), // Gurugram
                    zoom: 12,
                  ),
                  zoomControlsEnabled: false,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: const Color(0xFF2962FF),
                      width: 5,
                      points: const [
                        LatLng(28.6273, 77.3725), // Sector 62
                        LatLng(28.4950, 77.0878), // Cyber Hub
                      ],
                    ),
                  },
                ),
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
                    _buildFilterChip(Icons.bolt, 'Fastest', true),
                    const SizedBox(width: 12),
                    _buildFilterChip(Icons.payments_outlined, 'Cheapest', false),
                    const SizedBox(width: 12),
                    _buildFilterChip(Icons.directions_bus_outlined, 'Direct Only', false),
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
                children: routes.isEmpty
                    ? [
                        _buildRouteCard(
                          context,
                          title: 'Auto + Metro',
                          traffic: 'Moderate Traffic',
                          price: '₹85',
                          time: '22 mins',
                          isRecommended: true,
                          icon: Icons.electric_rickshaw,
                          footer: '1 Transfer • Leaving in 3m',
                        ),
                        const SizedBox(height: 16),
                        _buildRouteCard(
                          context,
                          title: 'Shared Tempo',
                          traffic: 'Low Congestion',
                          price: '₹40',
                          time: '35 mins',
                          isRecommended: false,
                          icon: Icons.airport_shuttle,
                          footer: '0 Transfers • 500m walk',
                        ),
                      ]
                    : List<Widget>.generate(routes.length, (index) {
                        final route = routes[index];
                        final firstLeg = route.legs.isNotEmpty ? route.legs.first : null;
                        final title = firstLeg == null ? 'Route ${index + 1}' : '${firstLeg.vehicle} route';
                        return Padding(
                          padding: EdgeInsets.only(bottom: index == routes.length - 1 ? 0 : 16),
                          child: _buildRouteCard(
                            context,
                            title: title,
                            traffic: 'Live crowds integrated',
                            price: '₹${route.totalFare.toStringAsFixed(0)}',
                            time: '${route.totalTimeMinutes} mins',
                            isRecommended: index == 0,
                            icon: Icons.alt_route,
                            footer: '${route.transfers} Transfers • ${route.path.join(' -> ')}',
                          ),
                        );
                      }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.search),
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
                            Text(traffic, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
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
              child: Row(
                children: [
                  const Icon(Icons.sync, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(footer.split('•')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(footer.split('•')[1], style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
