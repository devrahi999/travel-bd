import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/app_router.dart';
import '../providers/locale_provider.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.explore);
              break;
            case 2:
              context.go(AppRoutes.aiPlanner);
              break;
            case 3:
              context.go(AppRoutes.profile);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: tr('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore_rounded),
            label: tr('nav_explore'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome_rounded),
            label: tr('nav_ai'),
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
