import 'package:flutter/material.dart';
import '../../navigation/app_router.dart';
import '../../utils/app_images.dart';

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
        ),
        title: const Column(
          children: [
            Text(
              'Ride Completed',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'सवारी पूरी हुई',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Header
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  AppImages.rideMap,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Success Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF2962FF), size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              '₹25',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A)),
            ),
            const Text(
              'Final Fare / कुल किराया',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            // Rating Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'RATE YOUR DRIVER / रेटिंग दें',
                    style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 36),
                      Icon(Icons.star, color: Colors.orange, size: 36),
                      Icon(Icons.star, color: Colors.orange, size: 36),
                      Icon(Icons.star, color: Colors.orange, size: 36),
                      Icon(Icons.star_border, color: Colors.grey, size: 36),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Payment Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Color(0xFF2962FF), size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Payment Summary / भुगतान विवरण',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryRow('Base Fare / आधार किराया', '₹20.00'),
                  _buildSummaryRow('Taxes (GST) / कर', '₹2.50'),
                  _buildSummaryRow('Service Fee / सेवा शुल्क', '₹5.00'),
                  _buildSummaryRow('Wallet Deduction / वॉलेट कटौती', '- ₹2.50', isDeduction: true),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Paid / कुल भुगतान',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '₹25.00',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2962FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: BorderSide(color: Colors.grey.shade200),
                        backgroundColor: const Color(0xFFF1F5F9),
                      ),
                      icon: const Icon(Icons.download, color: Colors.black87),
                      label: const Text('Download Receipt / रसीद डाउनलोड करें', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Done / पूरा हुआ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thank you for riding with JanRide / जनराइड से जुड़ने के लिए धन्यवाद',
              style: TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isDeduction ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
