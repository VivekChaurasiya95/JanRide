import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/app_router.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/ride_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   // ✅ ADD
  await Firebase.initializeApp();              // ✅ ADD
  runApp(const JanRideApp());
}

class JanRideApp extends StatelessWidget {
  const JanRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<LocationService>(create: (_) => LocationService()),
        ProxyProvider<ApiService, AuthService>(
          update: (_, apiService, __) => AuthService(apiService),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthService>()),
          update: (_, authService, vm) => vm ?? AuthViewModel(authService),
        ),
        ChangeNotifierProxyProvider2<ApiService, LocationService, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<ApiService>(), context.read<LocationService>()),
          update: (_, apiService, locationService, vm) => vm ?? HomeViewModel(apiService, locationService),
        ),
        ChangeNotifierProxyProvider<ApiService, RideViewModel>(
          create: (context) => RideViewModel(context.read<ApiService>()),
          update: (_, apiService, vm) => vm ?? RideViewModel(apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JanRide',
        theme: ThemeData(
          primaryColor: const Color(0xFF2962FF),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        initialRoute: AppRouter.onboarding1,
        onGenerateRoute: AppRouter.generateRoute,
        onUnknownRoute: AppRouter.unknownRoute,
      ),
    );
  }
}
