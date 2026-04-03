import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/app_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_images.dart';
import '../../viewmodels/permission_viewmodel.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PermissionViewModel(context.read<ApiService>()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
                return;
              }
              Navigator.pushReplacementNamed(context, AppRouter.onboarding3);
            },
          ),
          title: const Text(
            'Permissions | अनुमति',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<PermissionViewModel>(
          builder: (context, viewModel, child) {
            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Column(
                  children: [
                    // Map Preview Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          AppImages.permissionMap,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Let's get started!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Text(
                      'चलिए शुरू करते हैं!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'JanRide needs a few permissions to give you the best experience.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'बेहतरीन अनुभव के लिए कुछ अनुमति आवश्यक हैं।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildPermissionTile(
                            icon: Icons.location_on,
                            title: 'Location Access | ',
                            hindiTitle: 'लोकेशन एक्सेस',
                            subtitle: 'To find rides near you | आपके पास राइड ढूंढने के लिए',
                            value: viewModel.locationEnabled,
                            enabled: !viewModel.isUpdatingLocation,
                            onChanged: (val) async {
                              final shouldShowPopup =
                                  await viewModel.setLocationEnabled(val);
                              if (!context.mounted || !shouldShowPopup) {
                                return;
                              }
                              await _showLocationGrantedDialog(context);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildPermissionTile(
                            icon: Icons.notifications,
                            title: 'Notifications | ',
                            hindiTitle: 'नोटिफिकेशन',
                            subtitle: 'For live trip updates | लाइव ट्रिप अपडेट के लिए',
                            value: viewModel.notificationsEnabled,
                            enabled: !viewModel.isUpdatingNotifications,
                            onChanged: (val) => viewModel.setNotificationsEnabled(val),
                          ),
                          const SizedBox(height: 16),
                          _buildPermissionTile(
                            icon: Icons.shield,
                            title: 'Safety First | ',
                            hindiTitle: 'सुरक्षा सबसे पहले',
                            subtitle: 'Data is encrypted & secure | आपका डेटा सुरक्षित है',
                            isStatic: true,
                            isVerified: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () async {
                                      var shouldShowPopup = false;
                                      try {
                                        shouldShowPopup =
                                            await viewModel.requestAll().timeout(
                                              const Duration(seconds: 6),
                                            );
                                      } catch (_) {
                                        shouldShowPopup = false;
                                      }
                                      if (!context.mounted) return;
                                      if (shouldShowPopup) {
                                        await _showLocationGrantedDialog(context);
                                        if (!context.mounted) return;
                                      }
                                      Navigator.pushReplacementNamed(context, AppRouter.language);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2962FF),
                                disabledBackgroundColor: const Color(0xFF2962FF).withValues(alpha: 0.55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Allow Access',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'अनुमति दें',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () async {
                                    await viewModel.markOnboardingComplete();
                                    if (!context.mounted) return;
                                    Navigator.pushReplacementNamed(context, AppRouter.language);
                                  },
                            child: const Text(
                              'Maybe Later | बाद में',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String hindiTitle,
    required String subtitle,
    bool value = false,
    Function(bool)? onChanged,
    bool isStatic = false,
    bool isVerified = false,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF2962FF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                    children: [
                      TextSpan(text: title),
                      TextSpan(text: hindiTitle),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isStatic)
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeThumbColor: const Color(0xFF2962FF),
              activeTrackColor:
                  const Color(0xFF2962FF).withValues(alpha: 0.2),
            ),
          if (isVerified)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.verified_user, color: Colors.grey, size: 20),
            ),
        ],
      ),
    );
  }

  Future<void> _showLocationGrantedDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Location Access Enabled'),
          content: const Text(
            'Great! JanRide can now use your location to find nearby rides.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
