import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_traveler_screen.dart';
import '../../features/auth/screens/register_business_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/traveler/home/home_screen.dart';
import '../../features/traveler/explore/explore_screen.dart';
import '../../features/traveler/explore/place_detail_screen.dart';
import '../../features/traveler/ai_planner/ai_planner_screen.dart';
import '../../features/traveler/hotels/hotel_list_screen.dart';
import '../../features/traveler/hotels/hotel_detail_screen.dart';
import '../../features/traveler/restaurants/restaurant_list_screen.dart';
import '../../features/traveler/restaurants/restaurant_detail_screen.dart';
import '../../features/traveler/guides/guide_list_screen.dart';
import '../../features/traveler/guides/guide_detail_screen.dart';
import '../../features/auth/screens/language_select_screen.dart';
import '../../features/traveler/packages/package_list_screen.dart';
import '../../features/traveler/packages/package_detail_screen.dart';
import '../../features/traveler/profile/profile_screen.dart';
import '../../features/traveler/profile/settings_screen.dart';
import '../../features/traveler/favorites/favorites_screen.dart';
import '../../features/traveler/notifications/notifications_screen.dart';
import '../../features/business/dashboard/business_dashboard_screen.dart';
import '../../features/business/listings/hotel_listing_screen.dart';
import '../../features/business/profile/business_profile_screen.dart';
import '../widgets/traveler_shell.dart';
import '../widgets/business_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String registerTraveler = '/register/traveler';
  static const String registerBusiness = '/register/business';
  static const String forgotPassword = '/forgot-password';


  // Traveler
  static const String home = '/home';
  static const String explore = '/explore';
  static const String placeDetail = '/place/:id';
  static const String aiPlanner = '/ai-planner';
  static const String hotelList = '/hotels';
  static const String hotelDetail = '/hotels/:id';
  static const String restaurantList = '/restaurants';
  static const String restaurantDetail = '/restaurants/:id';
  static const String guideList = '/guides';
  static const String guideDetail = '/guides/:id';
  static const String languageSelect = '/language-select';
  static const String packageList = '/packages';
  static const String packageDetail = '/packages/:id';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';

  // Business
  static const String businessDashboard = '/business';
  static const String businessListings = '/business/listings';
  static const String businessProfile = '/business/profile';
}

CustomTransitionPage<T> slidePageTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        child: child,
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerTraveler,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const RegisterTravelerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerBusiness,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const RegisterBusinessScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.languageSelect,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const LanguageSelectScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const FavoritesScreen(),
      ),
    ),
    GoRoute(
      path: '/place/:id',
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: PlaceDetailScreen(placeId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoutes.hotelList,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const HotelListScreen(),
      ),
    ),
    GoRoute(
      path: '/hotels/:id',
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: HotelDetailScreen(hotelId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoutes.restaurantList,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const RestaurantListScreen(),
      ),
    ),
    GoRoute(
      path: '/restaurants/:id',
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: RestaurantDetailScreen(restaurantId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoutes.guideList,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const GuideListScreen(),
      ),
    ),
    GoRoute(
      path: '/guides/:id',
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: GuideDetailScreen(guideId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoutes.packageList,
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: const PackageListScreen(),
      ),
    ),
    GoRoute(
      path: '/packages/:id',
      pageBuilder: (context, state) => slidePageTransition(
        context: context,
        state: state,
        child: PackageDetailScreen(packageId: state.pathParameters['id'] ?? ''),
      ),
    ),

    // Traveler shell (bottom nav)
    ShellRoute(
      builder: (context, state, child) => TravelerShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.explore,
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: AppRoutes.aiPlanner,
          builder: (context, state) => const AiPlannerScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Business shell
    ShellRoute(
      builder: (context, state, child) => BusinessShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.businessDashboard,
          builder: (context, state) => const BusinessDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.businessListings,
          builder: (context, state) => const HotelListingScreen(),
        ),
        GoRoute(
          path: AppRoutes.businessProfile,
          builder: (context, state) => const BusinessProfileScreen(),
        ),
      ],
    ),
  ],
);
