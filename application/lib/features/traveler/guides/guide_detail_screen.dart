import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class GuideDetailScreen extends StatelessWidget {
  final String guideId;
  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                child: Stack(
                  children: [
                    Positioned(top: -40, right: -40, child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
                    Positioned(
                      bottom: 20, left: 0, right: 0,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                            child: Text('ক', style: AppTextStyles.displayLg.copyWith(color: Colors.white, fontSize: 36)),
                          ),
                          const SizedBox(height: 10),
                          Text('করিম উদ্দিন', style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_rounded, size: 13, color: Colors.white70),
                              SizedBox(width: 4),
                              Text("Cox's Bazar", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
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
                // Stats row
                Row(
                  children: [
                    _StatCard(value: '4.8', label: 'রেটিং', icon: Icons.star_rounded, color: AppColors.starGold),
                    const SizedBox(width: 12),
                    _StatCard(value: '124', label: 'রিভিউ', icon: Icons.reviews_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    _StatCard(value: '5 বছর', label: 'অভিজ্ঞতা', icon: Icons.work_rounded, color: AppColors.secondary),
                  ],
                ),

                const SizedBox(height: 20),

                // Badges
                Row(
                  children: [
                    _Badge(icon: Icons.verified_rounded, label: 'Verified Guide', color: AppColors.primary),
                    const SizedBox(width: 8),
                    _Badge(icon: Icons.security_rounded, label: 'Background Checked', color: AppColors.successGreen),
                  ],
                ),

                const SizedBox(height: 20),

                // About
                Text('সম্পর্কে', style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Text(
                  'আমি কক্সবাজার এবং পার্শ্ববর্তী অঞ্চলে ৫ বছরেরও বেশি সময় ধরে ট্যুর গাইড হিসেবে কাজ করছি। সমুদ্র সৈকতের প্রতিটি কোণ আমার কাছে চেনা। আপনার পরিবার বা দলকে সেরা ভ্রমণ অভিজ্ঞতা দেওয়াই আমার লক্ষ্য।',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.7),
                ),

                const SizedBox(height: 20),

                // Services
                Text('সেবাসমূহ', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                ...[
                  {'service': 'সমুদ্র সৈকত ট্যুর', 'duration': 'সারাদিন', 'price': 1500},
                  {'service': 'হাফ-ডে ট্যুর', 'duration': 'হাফ ডে', 'price': 800},
                  {'service': 'সূর্যোদয় ট্যুর', 'duration': 'সকাল ৫-৮টা', 'price': 500},
                  {'service': 'প্রাইভেট গ্রুপ ট্যুর', 'duration': 'কাস্টম', 'price': 2500},
                ].map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.tour_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['service'] as String, style: AppTextStyles.titleMd),
                            Text(s['duration'] as String, style: AppTextStyles.labelSm),
                          ],
                        ),
                      ),
                      Text('৳${s['price']}', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                )),

                const SizedBox(height: 20),

                // Languages
                Text('ভাষা', style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8,
                  children: ['বাংলা', 'English'].map((l) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
                    ),
                    child: Text(l, style: AppTextStyles.labelLg.copyWith(color: AppColors.primaryContainer)),
                  )).toList(),
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://wa.me/8801800000000');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
                icon: const Icon(Icons.chat_rounded, size: 16),
                label: const Text('মেসেজ'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 50)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://wa.me/8801800000000');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
                icon: const Icon(Icons.chat_rounded, size: 16),
                label: const Text('WhatsApp Now'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  backgroundColor: const Color(0xFF25D366),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.titleMd.copyWith(color: color, fontWeight: FontWeight.w700)),
            Text(label, style: AppTextStyles.labelSm),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.labelSm.copyWith(color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
