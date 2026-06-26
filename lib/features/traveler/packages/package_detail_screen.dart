import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PackageDetailScreen extends StatelessWidget {
  final String packageId;
  const PackageDetailScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context) {
    final itinerary = [
      {'day': 'দিন ১', 'desc': 'ঢাকা থেকে রওনা, কক্সবাজারে পৌঁছানো, হোটেলে চেক-ইন, সন্ধ্যায় বিচ ওয়াক'},
      {'day': 'দিন ২', 'desc': 'সকাল ৫টায় সূর্যোদয়, দিনভর সমুদ্র সৈকত এক্সপ্লোর, ইনানী বিচ ভ্রমণ'},
      {'day': 'দিন ৩', 'desc': 'সেন্ট মার্টিন ডে ট্রিপ, বিকেলে কেনাকাটা, সন্ধ্যায় ঢাকার উদ্দেশ্যে রওনা'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800', fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer)),
                  const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.heroGradient)),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(20)),
                          child: const Text('বাজেট', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B4500))),
                        ),
                        const SizedBox(height: 6),
                        Text("Cox's Bazar Special", style: AppTextStyles.headlineMd.copyWith(color: Colors.white)),
                        Text('৩ দিন · ২ রাত · ঢাকা থেকে', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats
                Row(children: [
                  Expanded(child: _StatTile(icon: Icons.star_rounded, label: 'রেটিং', value: '4.6', color: AppColors.starGold)),
                  Expanded(child: _StatTile(icon: Icons.people_rounded, label: 'বুকিং', value: '420+', color: AppColors.primary)),
                  Expanded(child: _StatTile(icon: Icons.calendar_today_rounded, label: 'সময়কাল', value: '৩ দিন', color: AppColors.secondary)),
                ]),

                const SizedBox(height: 20),

                // Includes
                Text('প্যাকেজে যা আছে', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    _IncludeItem(icon: Icons.hotel_rounded, label: '৩★ হোটেল (২ রাত)'),
                    _IncludeItem(icon: Icons.directions_bus_rounded, label: 'এসি বাস (রাউন্ড ট্রিপ)'),
                    _IncludeItem(icon: Icons.person_pin_rounded, label: 'অভিজ্ঞ গাইড'),
                    _IncludeItem(icon: Icons.restaurant_rounded, label: 'সকালের নাশতা'),
                    _IncludeItem(icon: Icons.beach_access_rounded, label: 'বিচ ট্যুর'),
                    _IncludeItem(icon: Icons.directions_boat_rounded, label: 'বোট রাইড'),
                  ],
                ),

                const SizedBox(height: 20),

                // Itinerary
                Text('ভ্রমণ সূচি', style: AppTextStyles.headlineSm),
                const SizedBox(height: 12),
                ...itinerary.map((day) => Container(
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
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(day['day']!, style: AppTextStyles.labelSm.copyWith(color: Colors.white, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(day['desc']!, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5))),
                    ],
                  ),
                )),

                const SizedBox(height: 20),

                // Not included
                Text('প্যাকেজে যা নেই', style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                ...[
                  'বিমান বা ট্রেন টিকিট',
                  'লাঞ্চ ও ডিনার',
                  'ব্যক্তিগত কেনাকাটা',
                ].map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Icon(Icons.close_rounded, size: 16, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text(t, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                  ]),
                )),

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
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('৳8,500/জন', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
            Text('ট্যাক্স ও চার্জ সহ', style: AppTextStyles.labelSm),
          ])),
          Expanded(flex: 2, child: ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse('https://wa.me/8801800000000');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            icon: const Icon(Icons.chat_rounded),
            label: const Text('WhatsApp Now'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              backgroundColor: const Color(0xFF25D366),
            ),
          )),
        ]),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _StatTile({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 4),
      Text(value, style: AppTextStyles.titleMd.copyWith(color: color, fontWeight: FontWeight.w700)),
      Text(label, style: AppTextStyles.labelSm),
    ]);
  }
}

class _IncludeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IncludeItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: AppTextStyles.labelSm, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
