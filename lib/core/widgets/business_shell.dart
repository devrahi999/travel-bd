import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/app_router.dart';
import '../providers/locale_provider.dart';

class BusinessShell extends ConsumerWidget {
  final Widget child;
  const BusinessShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.businessDashboard) return 0;
    if (location.startsWith(AppRoutes.businessListings)) return 1;
    if (location.startsWith(AppRoutes.businessAnalytics)) return 2;
    if (location.startsWith(AppRoutes.businessProfile)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final tr = ref.watch(localeProvider.notifier).translate;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.businessDashboard);
              break;
            case 1:
              context.go(AppRoutes.businessListings);
              break;
            case 2:
              context.go(AppRoutes.businessAnalytics);
              break;
            case 3:
              context.go(AppRoutes.businessProfile);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard_rounded),
            label: tr('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store_outlined),
            activeIcon: const Icon(Icons.store_rounded),
            label: tr('home_quick_hotels'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart_rounded),
            label: tr('biz_quick_analytics'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: tr('nav_profile'),
          ),
        ],
      ),
    );
  }
}
