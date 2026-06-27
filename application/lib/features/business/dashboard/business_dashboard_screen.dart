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
                    _DashCard(title: 'মোট লিস্টিং', value: '5', icon: Icons.hotel_rounded, color: AppColors.primary, change: '+1').animate(delay: 50.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'গড় রেটিং', value: '4.8', icon: Icons.star_rounded, color: AppColors.starGold, change: '+0.2').animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'মোট রিভিউ', value: '124', icon: Icons.reviews_rounded, color: AppColors.infoBlue, change: '+12').animate(delay: 150.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                    _DashCard(title: 'প্রোফাইল ভিউ', value: '1.2k', icon: Icons.visibility_rounded, color: AppColors.successGreen, change: '+18%').animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick actions
                Text('দ্রুত কাজ', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                Row(children: [
                  _QuickAction(icon: Icons.add_business_rounded, label: 'লিস্টিং\nআপডেট', route: AppRoutes.businessListings, color: AppColors.primary),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.hotel_rounded, label: 'সব\nলিস্টিং', route: AppRoutes.businessListings, color: AppColors.infoBlue),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.reviews_rounded, label: 'রিভিউ\nদেখুন', route: AppRoutes.businessListings, color: AppColors.starGold),
                  const SizedBox(width: 10),
                  _QuickAction(icon: Icons.person_rounded, label: 'প্রোফাইল\nএডিট', route: AppRoutes.businessProfile, color: AppColors.secondary),
                ]).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: 24),

                // Recent Reviews preview
                SectionHeader(
                  title: 'সাম্প্রতিক রিভিউ',
                  actionLabel: 'সব দেখুন',
                  onAction: () => context.push(AppRoutes.businessListings),
                ),
                const SizedBox(height: 12),
                ...[
                  const _RecentReview(guest: 'রহিম মিয়া', review: 'অসাধারণ সার্ভিস! রুমগুলো খুব পরিষ্কার ছিল।', rating: 5.0, date: '১ জুলাই'),
                  const _RecentReview(guest: 'John Doe', review: 'Great location, but the food could be better.', rating: 4.0, date: '২ জুলাই'),
                  const _RecentReview(guest: 'সাদিয়া আক্তার', review: 'স্টাফদের ব্যবহার খুবই ভালো লেগেছে।', rating: 5.0, date: '৩ জুলাই'),
                ].map((b) => b.animate(delay: 300.ms).fadeIn().slideX(begin: 0.1)),

                const SizedBox(height: 30),

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

class _RecentReview extends StatelessWidget {
  final String guest, review, date;
  final double rating;
  const _RecentReview({required this.guest, required this.review, required this.rating, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CircleAvatar(radius: 20, backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.15),
            child: Text(guest[0], style: AppTextStyles.titleMd.copyWith(color: AppColors.primaryContainer))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(guest, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(date, style: AppTextStyles.labelSm),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.starGold, size: 14),
              const SizedBox(width: 4),
              Text(rating.toString(), style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(review, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        ])),
      ]),
    );
  }
}
