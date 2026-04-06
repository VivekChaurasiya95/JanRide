import 'package:flutter/material.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refer & Earn')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invite friends and earn ride credits',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Share your referral code with friends and get rewards after their first ride.'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.card_giftcard, color: Color(0xFF2962FF)),
                  SizedBox(width: 8),
                  Text('Referral Code: JANRIDE20', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Back to Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

