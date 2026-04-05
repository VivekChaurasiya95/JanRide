import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../navigation/app_router.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  static const int _resendSeconds = 45;

  String _phone = '+91';
  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  bool _didReadArgs = false;
  bool _focusScheduled = false;
  bool _isVerifying = false;
  bool _isNavigating = false;
  bool _errorRoutePushed = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _scheduleAutoFocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didReadArgs) {
      return;
    }
    final vm = context.read<AuthViewModel>();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _phone = args['phone']?.toString() ?? _phone;
    } else if (args is String && args.isNotEmpty) {
      _phone = args;
    } else if ((vm.lastRequestedPhone ?? '').isNotEmpty) {
      _phone = vm.lastRequestedPhone!;
    }
    _didReadArgs = true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    _errorRoutePushed = false;
    setState(() {});
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  bool get _hasCompleteOtp => _controllers.every((controller) => controller.text.trim().isNotEmpty);

  void _focusFirstEmptyField() {
    if (_hasCompleteOtp) {
      return;
    }
    for (var i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        if (!_focusNodes[i].hasFocus) {
          _focusNodes[i].requestFocus();
        }
        return;
      }
    }
    if (!_focusNodes.last.hasFocus) {
      _focusNodes.last.requestFocus();
    }
  }

  void _scheduleAutoFocus() {
    if (_focusScheduled) return;
    _focusScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusScheduled = false;
      if (!mounted) return;
      _focusFirstEmptyField();
    });
  }

  String _otpCode() => _controllers.map((e) => e.text).join();

  String get _countdownLabel {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _resendSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        setState(() {
          _secondsLeft = 0;
        });
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft -= 1;
      });
    });
  }

  Future<void> _onResendOtpPressed() async {
    if (_secondsLeft > 0) {
      return;
    }

    final vm = context.read<AuthViewModel>();
    _errorRoutePushed = false;
    if (_phone == '+91' && (vm.lastRequestedPhone ?? '').isNotEmpty) {
      _phone = vm.lastRequestedPhone!;
    }
    if (_phone == '+91') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number missing. Please go back and request OTP again.')),
      );
      return;
    }

    await vm.sendOtp(_phone);
    if (!mounted) return;

    if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
      return;
    }

    for (final controller in _controllers) {
      controller.clear();
    }
    _focusFirstEmptyField();
    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP re-sent successfully.')),
    );
  }

  Future<void> _onVerifyPressed() async {
    if (_isVerifying || _isNavigating) return;
    _isVerifying = true;
    final vm = context.read<AuthViewModel>();
    if (kDebugMode) {
      debugPrint('[OTP] verifyOtp called');
    }
    try {
      if (_phone == '+91') {
        if (!_errorRoutePushed) {
          _errorRoutePushed = true;
          Navigator.pushNamed(
            context,
            AppRouter.authError,
            arguments: 'Phone number session missing. Please go back and request OTP again.',
          );
        }
        return;
      }
      final otp = _otpCode();
      if (otp.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the 6-digit OTP.')),
        );
        return;
      }

      FocusScope.of(context).unfocus();
      vm.clearError();
      final success = await vm.verifyOtp(otp);
      if (!mounted) return;

      if (!success) {
        if (!_errorRoutePushed) {
          _errorRoutePushed = true;
          Navigator.pushNamed(context, AppRouter.authError, arguments: vm.errorMessage);
        }
        return;
      }

      if (_isNavigating) return;
      _isNavigating = true;
      Navigator.pushReplacementNamed(
        context,
        vm.profileCompleted ? AppRouter.home : AppRouter.profileSetup,
      );
    } finally {
      _isVerifying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.phonelink_lock,
                            size: 48,
                            color: Color(0xFF2962FF),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B2A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Enter the 6-digit code sent to',
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                        Text(
                          _phone,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B2A),
                          ),
                        ),
                        if (vm.otpAutoRetrievalTimedOut && !_hasCompleteOtp && !vm.isLoading) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFDA4AF)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFB91C1C)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Auto-read timed out. Enter OTP manually or tap RESEND OTP.',
                                    style: TextStyle(color: Color(0xFF9F1239), fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        LayoutBuilder(
                          builder: (context, boxConstraints) {
                            final boxWidth = ((boxConstraints.maxWidth - 40) / 6).clamp(42.0, 50.0);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: boxWidth,
                                  height: 64,
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    onChanged: (value) => _onChanged(value, index),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    autofillHints: [AutofillHints.oneTimeCode],
                                    maxLength: 1,
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Color(0xFF2962FF), width: 2),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, size: 20, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            const Text(
                              'Resend in ',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            Text(
                              _countdownLabel,
                              style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _secondsLeft == 0 && !vm.isLoading ? _onResendOtpPressed : null,
                          child: Text(
                            'RESEND OTP',
                            style: TextStyle(
                              color: _secondsLeft == 0 ? const Color(0xFF2962FF) : Colors.grey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: vm.isLoading ? null : _onVerifyPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2962FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  vm.isLoading ? 'Verifying...' : 'Verify & Proceed',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "By continuing, you agree to JanRide's Terms of Service and Privacy Policy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
