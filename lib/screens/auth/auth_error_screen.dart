import 'package:flutter/material.dart';

import '../../navigation/app_router.dart';

class AuthErrorScreen extends StatelessWidget {
  const AuthErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments?.toString() ??
        'Login failed. Please check your connection.';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B2A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'Electric Slate',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1B2A),
                ),
              ),
            ),
            Text(
              'JanRide',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D1B2A),
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFEE2E2),
                  ),
                  child: const Icon(Icons.wifi_off_rounded, color: Color(0xFFEF4444), size: 62),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Authentication Error',
              style: TextStyle(
                color: Color(0xFF0D1B2A),
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We encountered a problem while trying\nto sign you in.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFCA5A5), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Color(0xFFDC2626)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRouter.support),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD1D9E6), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text(
                  'Contact Support',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 26),
            const Text('Common issues:', style: TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _IssueChip(label: 'WI-FI DISABLED'),
                _IssueChip(label: 'WRONG OTP'),
                _IssueChip(label: 'SERVER TIMEOUT'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IssueChip extends StatelessWidget {
  const _IssueChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

