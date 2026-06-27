import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/locale_provider.dart';

class PlaceDetailScreen extends ConsumerStatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  ConsumerState<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  bool _isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  final _images = [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
  ];
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _showTitle = _scrollController.offset > 250);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;
    final placeName = isBn ? "কক্সবাজার সমুদ্র সৈকত" : "Cox's Bazar Beach";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: 200.ms,
              child: Text(placeName, style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemCount: _images.length,
                    itemBuilder: (ctx, i) => Image.network(_images[i], fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer)),
                  ),
                  const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.heroGradient)),
                  // Image dots
                  Positioned(
                    bottom: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${_currentImage + 1}/${_images.length}',
                          style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Name + rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(placeName, style: AppTextStyles.headlineLgMobile),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 16, color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(isBn ? 'কক্সবাজার, চট্টগ্রাম' : 'Cox\'s Bazar, Chattogram',
                                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const StarRating(rating: 4.8, reviewCount: 1240),
                  ],
                ),

                const SizedBox(height: 16),

                // Quick info chips
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    _InfoChip(icon: Icons.wb_sunny_rounded, label: isBn ? 'অক্টোবর - মার্চ' : 'October - March'),
                    _InfoChip(icon: Icons.people_rounded, label: isBn ? 'পরিবার বান্ধব' : 'Family Friendly'),
                    _InfoChip(icon: Icons.attach_money_rounded, label: isBn ? 'প্রবেশ মূল্য নেই' : 'No Entry Fee'),
                    _InfoChip(icon: Icons.photo_camera_rounded, label: isBn ? 'ফটোজেনিক' : 'Photogenic'),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 20),

                // Description
                Text(tr('detail_about_header'), style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Text(
                  isBn
                      ? 'কক্সবাজার বাংলাদেশের দক্ষিণ-পূর্বাঞ্চলে অবস্থিত একটি শহর, জেলা এবং বন্দর। এটি বিশ্বের দীর্ঘতম প্রাকৃতিক সমুদ্র সৈকতের জন্য বিখ্যাত। সমুদ্র সৈকতটি প্রায় ১২০ কিলোমিটার দীর্ঘ। ঢেউয়ের শব্দ, সূর্যোদয় ও সূর্যাস্তের অপরূপ দৃশ্য এই স্থানকে অনন্য করে তুলেছে।'
                      : 'Cox\'s Bazar is a town, district, and port located on the southeastern coast of Bangladesh. It is famous for having the world\'s longest natural sandy beach, stretching over 120 km. The roaring waves, stunning sunrises, and sunsets make it a truly unique place.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.7,
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 20),

                // How to get there
                _SectionCard(
                  icon: Icons.directions_rounded,
                  title: tr('detail_how_to_go'),
                  child: Column(
                    children: [
                      _TransportRow(
                        icon: Icons.directions_bus_rounded,
                        label: isBn ? 'বাস (ঢাকা থেকে)' : 'Bus (from Dhaka)',
                        info: isBn ? '৮-১০ ঘণ্টা · ৫০০-১৫০০৳' : '8-10 hrs · ৳500-1500',
                      ),
                      const Divider(height: 20),
                      _TransportRow(
                        icon: Icons.flight_rounded,
                        label: isBn ? 'বিমান (ঢাকা থেকে)' : 'Flight (from Dhaka)',
                        info: isBn ? '১ ঘণ্টা · ৩০০০-৮০০০৳' : '1 hr · ৳3000-8000',
                      ),
                      const Divider(height: 20),
                      _TransportRow(
                        icon: Icons.train_rounded,
                        label: isBn ? 'ট্রেন (চট্টগ্রাম থেকে)' : 'Train (from Chattogram)',
                        info: isBn ? '২.৫ ঘণ্টা · ২০০-৫০০৳' : '2.5 hrs · ৳200-500',
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                // Location card
                _SectionCard(
                  icon: Icons.location_on_rounded,
                  title: isBn ? 'অবস্থান' : 'Location',
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_outlined, size: 36, color: AppColors.outline),
                              const SizedBox(height: 8),
                              Text(tr('detail_map_loading'), style: AppTextStyles.labelMd),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.directions_outlined),
                        label: Text(tr('detail_open_google_maps')),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 250.ms),

                const SizedBox(height: 16),

                // Nearby hotels
                SectionHeader(
                  title: tr('detail_nearby_hotels'),
                  actionLabel: tr('see_all'),
                  onAction: () => context.push('/hotels'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (ctx, i) => Padding(
                      padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                      child: _NearbyCard(
                        name: ['Sea Pearl', 'Long Beach', 'Ocean View'][i],
                        distance: ['0.5', '1.2', '2.1'][i],
                        price: [5000, 3500, 2800][i],
                        icon: Icons.hotel_rounded,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Reviews
                SectionHeader(
                  title: tr('detail_reviews_ratings'),
                  actionLabel: tr('see_all'),
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                ...[
                  _ReviewCard(
                    name: isBn ? 'রাহেলা বেগম' : 'Rahela Begum',
                    rating: 5,
                    comment: isBn
                        ? 'অসাধারণ জায়গা! সূর্যোদয় দেখতে ভোরবেলা যাওয়াটা মিস করবেন না।'
                        : 'Amazing place! Don\'t miss going early in the morning to see the sunrise.',
                    date: isBn ? '২ দিন আগে' : '2 days ago',
                  ),
                  _ReviewCard(
                    name: isBn ? 'তানভীর আহমেদ' : 'Tanvir Ahmed',
                    rating: 4,
                    comment: isBn
                        ? 'পরিবার নিয়ে গিয়ে দারুণ সময় কাটিয়েছি। সমুদ্র সৈকত খুবই পরিষ্কার ছিল।'
                        : 'Spent a great time with family. The beach was very clean.',
                    date: isBn ? '১ সপ্তাহ আগে' : '1 week ago',
                  ),
                ],

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),

      // Bottom action bar
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
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  tr('detail_add_trip'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/hotels'),
                icon: const Icon(Icons.hotel_rounded),
                label: Text(
                  tr('detail_book_hotel'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.labelMd),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.titleMd),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TransportRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String info;
  const _TransportRow({required this.icon, required this.label, required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.bodyMd)),
        Text(info, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final String name;
  final String distance;
  final int price;
  final IconData icon;
  const _NearbyCard({required this.name, required this.distance, required this.price, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryContainer),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$distance km · ৳$price', style: AppTextStyles.labelSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String date;
  const _ReviewCard({required this.name, required this.rating, required this.comment, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                child: Text(name[0], style: AppTextStyles.titleMd.copyWith(color: AppColors.primaryContainer)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMd),
                    Text(date, style: AppTextStyles.labelSm),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 14,
                  color: AppColors.starGold,
                )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5)),
        ],
      ),
    );
  }
}
