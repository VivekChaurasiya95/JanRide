import 'package:flutter/material.dart';

// Import screens
import '../screens/alerts/notifications_screen.dart';
import '../screens/auth/language_screen.dart';
import '../screens/auth/auth_error_screen.dart';
import '../screens/onboarding/permission_screen.dart' as onboarding;
import '../screens/onboarding/onboarding_1.dart';
import '../screens/onboarding/onboarding_2.dart';
import '../screens/onboarding/onboarding_3.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/search_screen.dart';
import '../screens/home/route_results_screen.dart';
import '../screens/home/booking_status_screen.dart';
import '../screens/home/tracking_screen.dart';
import '../screens/home/ride_completed_screen.dart';
import '../screens/home/rating_feedback_screen.dart';
import '../screens/home/driver_detail_screen.dart';
import '../screens/home/connection_lost_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_privacy_screen.dart';
import '../screens/profile/help_support_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/wallet_screen.dart';
import '../screens/profile/activity_history_screen.dart';
import '../screens/profile/favorite_routes_screen.dart';
import '../screens/profile/refer_earn_screen.dart';
import '../screens/profile/user_dashboard_screen.dart';

class AppRouter {
  static const onboarding1 = '/';
  static const onboarding2 = '/onboarding2';
  static const onboarding3 = '/onboarding3';
  static const permissions = '/permissions';
  static const language = '/language';
  static const login = '/login';
  static const otp = '/otp';
  static const authError = '/auth_error';
  static const profileSetup = '/profile_setup';
  static const home = '/home';
  static const search = '/search';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const settingsPrivacy = '/settings_privacy';
  static const support = '/support';
  // Backward-compatible aliases used by older screens.
  static const profileSettings = settingsPrivacy;
  static const alerts = notifications;
  static const profileHelp = support;
  static const editProfile = '/edit_profile';
  static const wallet = '/wallet';
  static const dashboard = '/dashboard';
  static const activityHistory = '/activity_history';
  static const favoriteRoutes = '/favorite_routes';
  static const referEarn = '/refer_earn';
  static const routeResults = '/route_results';
  static const bookingStatus = '/booking_status';
  static const tracking = '/tracking';
  static const rideCompleted = '/ride_completed';
  static const ratingFeedback = '/rating_feedback';
  static const driverDetails = '/driver_details';
  static const connectionLost = '/connection_lost';

  static int bottomNavIndexForRoute(String? routeName) {
    switch (routeName) {
      case home:
        return 0;
      case routeResults:
      case bookingStatus:
      case tracking:
        return 1;
      case dashboard:
      case activityHistory:
      case favoriteRoutes:
      case referEarn:
        return 2;
      case notifications:
        return 3;
      case profile:
      case settingsPrivacy:
      case editProfile:
        return 4;
      default:
        return 0;
    }
  }

  static String routeForBottomNavIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return routeResults; // Or search
      case 2:
        return dashboard;
      case 3:
        return notifications;
      case 4:
        return profile;
      default:
        return home;
    }
  }

  static void navigateFromBottomNav(
    BuildContext context, {
    required int tappedIndex,
    required int currentIndex,
  }) {
    if (tappedIndex == currentIndex) return;
    Navigator.pushReplacementNamed(
      context,
      routeForBottomNavIndex(tappedIndex),
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding1:
        return MaterialPageRoute(builder: (_) => const Onboarding1());

      case onboarding2:
        return MaterialPageRoute(builder: (_) => const Onboarding2());

      case onboarding3:
        return MaterialPageRoute(builder: (_) => const Onboarding3());

      case permissions:
        return MaterialPageRoute(builder: (_) => const onboarding.PermissionScreen());

      case language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otp:
        return MaterialPageRoute(builder: (_) => const OTPScreen());

      case authError:
        return MaterialPageRoute(builder: (_) => const AuthErrorScreen());

      case profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case settingsPrivacy:
        return MaterialPageRoute(builder: (_) => const SettingsPrivacyScreen());

      case support:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());

      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const UserDashboardScreen());

      case activityHistory:
        return MaterialPageRoute(builder: (_) => const ActivityHistoryScreen());

      case favoriteRoutes:
        return MaterialPageRoute(builder: (_) => const FavoriteRoutesScreen());

      case referEarn:
        return MaterialPageRoute(builder: (_) => const ReferEarnScreen());

      case routeResults:
        return MaterialPageRoute(builder: (_) => const RouteResultsScreen());

      case bookingStatus:
        return MaterialPageRoute(builder: (_) => const BookingStatusScreen());

      case tracking:
        return MaterialPageRoute(builder: (_) => const TrackingScreen());

      case rideCompleted:
        return MaterialPageRoute(builder: (_) => const RideCompletedScreen());

      case ratingFeedback:
        return MaterialPageRoute(builder: (_) => const RatingFeedbackScreen());

      case driverDetails:
        return MaterialPageRoute(builder: (_) => const DriverDetailScreen());

      case connectionLost:
        return MaterialPageRoute(builder: (_) => const ConnectionLostScreen());

      default:
        return unknownRoute(settings);
    }
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const Scaffold(
        body: Center(child: Text('No Route Found')),
      ),
    );
  }
}
