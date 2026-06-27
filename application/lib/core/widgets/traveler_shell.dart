import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/app_router.dart';
import '../providers/locale_provider.dart';
import '../constants/app_colors.dart';

class TravelerShell extends ConsumerWidget {
  final Widget child;
  const TravelerShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/ai-planner')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final tr = ref.watch(localeProvider.notifier).translate;

    return Scaffold(
      body: child,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          backgroundColor: AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primaryContainer,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          onDestinationSelected: (idx) {
            if (idx == 0) context.go(AppRoutes.home);
            if (idx == 1) context.go(AppRoutes.explore);
            if (idx == 2) context.go(AppRoutes.aiPlanner);
            if (idx == 3) context.go(AppRoutes.profile);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.onPrimaryContainer),
              label: tr('nav_home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded, color: AppColors.onPrimaryContainer),
              label: tr('nav_explore'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded, color: AppColors.onPrimaryContainer),
              label: tr('nav_ai'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.onPrimaryContainer),
              label: tr('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}
