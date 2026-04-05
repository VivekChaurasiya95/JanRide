import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../../utils/app_images.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _skipLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.home,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _normalizedPhone() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return '+91$digits';
  }

  Future<void> _onGetOtpTapped() async {
    final vm = context.read<AuthViewModel>();
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number.')),
      );
      return;
    }

    await vm.sendOtp(_normalizedPhone());
    if (!mounted) return;

    if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRouter.otp,
      arguments: {'phone': _normalizedPhone()},
    );
  }

  Future<void> _onGoogleSignInTapped() async {
    final vm = context.read<AuthViewModel>();
    final profileCompleted = await vm.signInWithGoogle();
    if (!mounted) return;

    if (vm.errorMessage != null) {
      Navigator.pushNamed(context, AppRouter.authError, arguments: vm.errorMessage);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      profileCompleted ? AppRouter.home : AppRouter.profileSetup,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AppImages.dashboardBanner,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x99031A4A), Color(0xFFF7F9FC)],
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B2A)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const Expanded(
                                  child: Text(
                                    'JanRide',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: vm.isLoading ? null : _skipLogin,
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 36,
                          bottom: 24,
                          right: 36,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Move with\nPrecision.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  height: 1.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Log in to start your journey with JanRide.',
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7F9FC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38),
                            topRight: Radius.circular(38),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PHONE NUMBER',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 74,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFD1D9E6), width: 2),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  const Text(
                                    '+91',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 38,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 18),
                                    width: 2,
                                    height: 40,
                                    color: const Color(0xFFDCE3EE),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(fontSize: 40, color: Color(0xFF0D1B2A)),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter 10 digit mobile',
                                        hintStyle: TextStyle(fontSize: 22, color: Color(0xFF94A3B8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 66,
                              child: ElevatedButton(
                                onPressed: vm.isLoading ? null : _onGetOtpTapped,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get OTP',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '| OTP bhejein',
                                      style: TextStyle(fontSize: 16, color: Color(0xB3FFFFFF)),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                const Expanded(child: Divider(color: Color(0xFFD1D9E6))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Text(
                                    'OR LOGIN WITH',
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: Color(0xFFD1D9E6))),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: OutlinedButton.icon(
                                onPressed: vm.isLoading ? null : _onGoogleSignInTapped,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFD1D9E6), width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                icon: const Text('G', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red, fontSize: 24)),
                                label: const Text(
                                  'Continue with Google',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0D1B2A)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton.icon(
                                onPressed: vm.isLoading ? null : _skipLogin,
                                icon: const Icon(Icons.skip_next_rounded, size: 18),
                                label: const Text(
                                  'Skip Login',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'By continuing, you agree to JanRide\'s\n',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (vm.isLoading) const _SigningInOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class _SigningInOverlay extends StatelessWidget {
  const _SigningInOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xAA111827),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 82,
                height: 82,
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    CircularProgressIndicator(strokeWidth: 5),
                    Icon(Icons.person_outline, color: Color(0xFF2563EB)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Signing in...',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign-in ho raha hai...',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Color(0xFF2563EB), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'SECURE AUTH',
                      style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
