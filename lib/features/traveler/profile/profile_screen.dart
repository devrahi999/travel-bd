import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/providers/locale_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                child: Stack(
                  children: [
                    Positioned(top: -40, right: -40, child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
                    SafeArea(
                      child: Padding(
                         padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 70, height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                                  ),
                                  child: const Icon(Icons.person_rounded, size: 36, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(isEnglish ? 'Abdul Karim' : 'আব্দুল করিম', style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
                                      Text('karim@email.com', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        const Icon(Icons.location_on_rounded, size: 12, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Text(isEnglish ? 'Dhaka, Bangladesh' : 'ঢাকা, বাংলাদেশ', style: AppTextStyles.labelSm.copyWith(color: Colors.white70)),
                                      ]),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats
                Row(children: [
                  Expanded(child: _StatBox(value: '12', label: tr('profile_stats_trips'))),
                  const SizedBox(width: 12),
                  Expanded(child: _StatBox(value: '24', label: tr('nav_bookings'))),
                  const SizedBox(width: 12),
                  Expanded(child: _StatBox(value: '8', label: tr('profile_stats_reviews'))),
                ]),

                const SizedBox(height: 24),

                // Traveler badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr('profile_gold_traveler'), style: AppTextStyles.titleMd.copyWith(color: AppColors.onSecondaryContainer, fontWeight: FontWeight.w700)),
                            Text(tr('profile_trips_completed'), style: AppTextStyles.labelMd.copyWith(color: AppColors.onSecondaryContainer)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.onSecondaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(isEnglish ? 'Upgrade' : 'আপগ্রেড', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSecondaryContainer, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Menu
                Text(tr('profile_menu_account_header'), style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                ..._menuItems(context, tr),

                const SizedBox(height: 20),

                // Switch to Business
                GestureDetector(
                  onTap: () => context.go(AppRoutes.businessDashboard),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.store_rounded, color: AppColors.primaryContainer, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(tr('profile_menu_biz_header'), style: AppTextStyles.titleMd),
                        Text(tr('profile_menu_biz_desc'), style: AppTextStyles.labelSm),
                      ])),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.onSurfaceVariant),
                    ]),
                  ),
                ),

                const SizedBox(height: 16),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.login),
                    icon: Icon(Icons.logout_rounded, color: AppColors.error),
                    label: Text(tr('profile_logout'), style: AppTextStyles.button.copyWith(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _menuItems(BuildContext context, String Function(String) tr) {
    final items = [
      {'icon': Icons.person_outline_rounded, 'label': tr('profile_menu_edit'), 'route': ''},
      {'icon': Icons.favorite_outline_rounded, 'label': tr('profile_menu_favs'), 'route': AppRoutes.favorites},

      {'icon': Icons.settings_rounded, 'label': tr('profile_settings'), 'route': AppRoutes.settings},
      {'icon': Icons.help_outline_rounded, 'label': tr('profile_menu_support'), 'route': ''},
    ];

    return items.map((item) => Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item['icon'] as IconData, color: AppColors.onBackground, size: 20),
        ),
        title: Text(item['label'] as String, style: AppTextStyles.bodyMd),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.onSurfaceVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.surfaceContainerLowest,
        onTap: () {
          final route = item['route'] as String;
          if (route.isNotEmpty) context.push(route);
        },
      ),
    )).toList();
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
      ),
      child: Column(children: [
        Text(value, style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
        Text(label, style: AppTextStyles.labelSm),
      ]),
    );
  }
}
