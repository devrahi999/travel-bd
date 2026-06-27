import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import '../services/app_router.dart';
import '../providers/locale_provider.dart';

class BusinessShell extends ConsumerWidget {
  final Widget child;
  const BusinessShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.businessDashboard) return 0;
    if (location.startsWith(AppRoutes.businessListings)) return 1;
    if (location.startsWith(AppRoutes.businessProfile)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final tr = ref.watch(localeProvider.notifier).translate;

    return AdaptiveScaffold(
      body: child,
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        items: [
          AdaptiveNavigationDestination(
            icon: 'square.grid.3x3.fill',
            label: tr('nav_home'),
          ),
          AdaptiveNavigationDestination(
            icon: 'building.2',
            label: tr('home_quick_hotels'),
          ),
          AdaptiveNavigationDestination(
            icon: 'person.fill',
            label: tr('nav_profile'),
          ),
        ],
        selectedIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.businessDashboard);
              break;
            case 1:
              context.go(AppRoutes.businessListings);
              break;
            case 2:
              context.go(AppRoutes.businessProfile);
              break;
          }
        },
        useNativeBottomBar: true,
      ),
    );
  }
}
