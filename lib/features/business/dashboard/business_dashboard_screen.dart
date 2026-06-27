import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                child: Stack(
                  children: [
                    Positioned(top: -50, right: -50, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.store_rounded, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Business Dashboard', style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
                                      Text('Long Beach Hotel', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('স্বাগতম! আজকের ব্যবসার সারসংক্ষেপ দেখুন।',
                                style: AppTextStyles.bodyMd.copyWith(color: Colors.white70)),
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
                // Today's stats
                Text('আজকের পারফর্মেন্স', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _DashCard(title: 'মোট বুকিং', value: '24', icon: Icons.confirmation_number_rounded, color: AppColors.primary, change: '+12%').animate(delay: 50.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'আজকের আয়', value: '৳45,200', icon: Icons.payments_rounded, color: AppColors.successGreen, change: '+8%').animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'নতুন রিভিউ', value: '7', icon: Icons.star_rounded, color: AppColors.starGold, change: '+3').animate(delay: 150.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'চেক-ইন আজ', value: '8', icon: Icons.login_rounded, color: AppColors.infoBlue, change: '5 বাকি').animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick actions
                Text('দ্রুত কাজ', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                Row(children: [
                  _QuickAction(icon: Icons.add_business_rounded, label: 'লিস্টিং\nআপডেট', route: AppRoutes.businessListings, color: AppColors.primary),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.calendar_month_rounded, label: 'Analytics\nদেখুন', route: AppRoutes.businessAnalytics, color: AppColors.infoBlue),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.bar_chart_rounded, label: 'Analytics', route: AppRoutes.businessAnalytics, color: AppColors.secondary),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.reviews_rounded, label: 'রিভিউ', route: AppRoutes.businessAnalytics, color: AppColors.starGold),
                ]).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: 24),

                // Recent bookings preview
                SectionHeader(
                  title: 'সাম্প্রতিক পরিচালনা',
                  actionLabel: 'Analytics দেখুন',
                  onAction: () => context.push(AppRoutes.businessAnalytics),
                ),
                const SizedBox(height: 12),
                ...[
                  const _RecentBooking(guest: 'আব্দুল করিম', type: 'ডবল রুম', date: '১ জুলাই', amount: 2800, status: 'Confirmed'),
                  const _RecentBooking(guest: 'Sakura Tanaka', type: 'সুইট', date: '২ জুলাই', amount: 6500, status: 'Pending'),
                  const _RecentBooking(guest: 'রাহেলা বেগম', type: 'সিঙ্গেল রুম', date: '৩ জুলাই', amount: 1800, status: 'Confirmed'),
                ].map((b) => b.animate(delay: 300.ms).fadeIn().slideX(begin: 0.1)),

                const SizedBox(height: 24),

                // Monthly chart placeholder
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('মাসিক আয়', style: AppTextStyles.headlineSm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text('জুন ২০২৬', style: AppTextStyles.labelMd.copyWith(color: AppColors.primaryContainer)),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Text('৳3,24,000', style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
                      Text('+15% গত মাসের তুলনায়', style: AppTextStyles.labelMd.copyWith(color: AppColors.successGreen)),
                      const SizedBox(height: 16),
                      // Simple bar chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 1.0, 0.7, 0.85, 0.6, 0.75, 0.9].map((h) => AnimatedContainer(
                          duration: 800.ms,
                          width: 20,
                          height: 80 * h,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['জা', 'ফে', 'মা', 'এ', 'মে', 'জু', 'জু', 'আ', 'সে', 'অ', 'ন', 'ড'].map((m) =>
                            Text(m, style: AppTextStyles.labelSm)).toList(),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String title, value, change;
  final IconData icon;
  final Color color;
  const _DashCard({required this.title, required this.value, required this.icon, required this.color, required this.change});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(change, style: AppTextStyles.labelSm.copyWith(color: color, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onBackground, fontWeight: FontWeight.w700)),
              Text(title, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label, route;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.route, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.labelSm.copyWith(color: color, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

class _RecentBooking extends StatelessWidget {
  final String guest, type, date, status;
  final int amount;
  const _RecentBooking({required this.guest, required this.type, required this.date, required this.amount, required this.status});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'Confirmed';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.15),
            child: Text(guest[0], style: AppTextStyles.titleMd.copyWith(color: AppColors.primaryContainer))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(guest, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('$type · $date', style: AppTextStyles.labelSm),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('৳$amount', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          StatusBadge(label: status, color: isConfirmed ? AppColors.successGreen : AppColors.starGold),
        ]),
      ]),
    );
  }
}
