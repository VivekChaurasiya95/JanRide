import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../navigation/app_router.dart';
import '../../widgets/bottom_nav_bar.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map Background
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(26.2124, 78.1772), // Gwalior
              zoom: 15,
            ),
            zoomControlsEnabled: false,
          ),

          // Custom AppBar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, AppRouter.home);
                      }
                    },
                  ),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ARRIVING IN 8 MINS',
                          style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Central Station / मुख्य स्टेशन',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'SOS',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My Location Button
          Positioned(
            right: 20,
            bottom: 420,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {},
              child: const Icon(Icons.my_location, color: Colors.blueGrey),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  // Vehicle & Driver Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5FF), borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.electric_rickshaw, color: Color(0xFF2962FF), size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'E-Rickshaw: MP07 AB 1234',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Rajesh Kumar • 4.8 ★',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                                child: const Icon(Icons.call, size: 20),
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                                child: const Icon(Icons.share, size: 20),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  // Timeline
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildTimelineItem(
                          title: 'Main Market / मुख्य बाज़ार',
                          time: '10:15 AM',
                          isDone: true,
                          isCurrent: false,
                        ),
                        _buildTimelineItem(
                          title: 'City Hospital / सिटी अस्पताल',
                          subtitle: 'Current Stop',
                          time: 'Now',
                          isDone: false,
                          isCurrent: true,
                        ),
                        _buildTimelineItem(
                          title: 'Railway Crossing / रेलवे क्रॉसिंग',
                          time: '4 mins',
                          isDone: false,
                          isCurrent: false,
                        ),
                        _buildTimelineItem(
                          title: 'Central Station / मुख्य स्टेशन',
                          time: '8 mins',
                          isDone: false,
                          isCurrent: false,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            icon: const Icon(Icons.share_outlined, color: Colors.black87),
                            label: const Text('Share Trip', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.wb_sunny_outlined, color: Colors.white),
                            label: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.tracking),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    String? subtitle,
    required String time,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : (isCurrent ? const Color(0xFF2962FF) : Colors.white),
                border: Border.all(
                  color: isDone ? Colors.green : (isCurrent ? const Color(0xFF2962FF) : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : (isCurrent ? Container(margin: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? Colors.green : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCurrent ? const Color(0xFF2962FF) : (isDone ? Colors.grey : Colors.black87),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF2962FF), fontSize: 12, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: isCurrent ? const Color(0xFF2962FF) : Colors.grey,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
