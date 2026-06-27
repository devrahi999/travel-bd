import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../core/providers/locale_provider.dart';

class HotelListScreen extends ConsumerStatefulWidget {
  const HotelListScreen({super.key});

  @override
  ConsumerState<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends ConsumerState<HotelListScreen> {
  bool _isListView = true;
  RangeValues _priceRange = const RangeValues(500, 10000);
  double _minRating = 0;
  final Set<String> _amenities = {};
  final bool _isLoading = false;

  final List<_HotelData> _hotels = [
    const _HotelData(id: '1', name: "Long Beach Hotel", location: "Cox's Bazar", price: 3500, rating: 4.7, reviews: 480, imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800', amenities: ['WiFi', 'AC', 'Pool', 'Restaurant']),
    const _HotelData(id: '2', name: "Sea Pearl Beach Resort", location: "Cox's Bazar", price: 5500, rating: 4.8, reviews: 620, imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800', amenities: ['WiFi', 'AC', 'Pool', 'Spa']),
    const _HotelData(id: '3', name: "Sajek Eco Resort", location: "Rangamati", price: 2800, rating: 4.5, reviews: 230, imageUrl: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', amenities: ['WiFi', 'Restaurant']),
    const _HotelData(id: '4', name: "Royal Tulip Dhaka", location: "Dhaka", price: 8000, rating: 4.9, reviews: 850, imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800', amenities: ['WiFi', 'AC', 'Pool', 'Gym', 'Spa']),
    const _HotelData(id: '5', name: "Sundarban Hotel", location: "Khulna", price: 1800, rating: 4.2, reviews: 140, imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', amenities: ['AC', 'Restaurant']),
    const _HotelData(id: '6', name: "Hill View Resort", location: "Bandarban", price: 3200, rating: 4.4, reviews: 190, imageUrl: 'https://images.unsplash.com/photo-1601918774946-25832a4be0d6?w=800', amenities: ['WiFi', 'Restaurant', 'Parking']),
  ];

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context)),
        title: Text(tr('hotels_title'), style: AppTextStyles.headlineSm),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view_rounded : Icons.view_list_rounded),
            onPressed: () => setState(() => _isListView = !_isListView),
          ),
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: _showFilters),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _FilterChip(label: tr('hotels_filter_price'), icon: Icons.attach_money_rounded, onTap: _showFilters),
                _FilterChip(label: tr('hotels_filter_rating'), icon: Icons.star_rounded, onTap: _showFilters),
                _FilterChip(label: 'WiFi', icon: Icons.wifi_rounded, onTap: () {}),
                _FilterChip(label: tr('hotels_filter_pool'), icon: Icons.pool_rounded, onTap: () {}),
                _FilterChip(label: 'AC', icon: Icons.ac_unit_rounded, onTap: () {}),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: _isListView
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: _hotels.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HotelListCard(hotel: _hotels[i])
                          .animate(delay: (i * 60).ms).fadeIn().slideX(begin: -0.1),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: _hotels.length,
                    itemBuilder: (ctx, i) => _HotelGridCard(hotel: _hotels[i])
                        .animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    GlassTheme.showGlassBottomSheet(
      context: context,
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('ফিল্টার', style: AppTextStyles.headlineSm),
                  const Spacer(),
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('রিসেট')),
                ],
              ),
              const SizedBox(height: 16),
              Text('মূল্য পরিসীমা', style: AppTextStyles.titleMd),
              RangeSlider(
                values: _priceRange,
                min: 500, max: 15000,
                divisions: 30,
                activeColor: AppColors.primary,
                labels: RangeLabels('৳${_priceRange.start.round()}', '৳${_priceRange.end.round()}'),
                onChanged: (v) { setModal(() => _priceRange = v); setState(() => _priceRange = v); },
              ),
              Text('ন্যূনতম রেটিং', style: AppTextStyles.titleMd),
              AdaptiveSlider(
                value: _minRating, min: 0, max: 5,
                onChanged: (v) { setModal(() => _minRating = v); setState(() => _minRating = v); },
              ),
              const SizedBox(height: 8),
              Text('সুবিধাসমূহ', style: AppTextStyles.titleMd),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['WiFi', 'AC', 'Pool', 'Gym', 'Spa', 'Restaurant', 'Parking'].map((a) => FilterChip(
                  label: Text(a, style: AppTextStyles.labelMd),
                  selected: _amenities.contains(a),
                  onSelected: (v) {
                    setModal(() => v ? _amenities.add(a) : _amenities.remove(a));
                    setState(() {});
                  },
                  selectedColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                )).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('ফিল্টার প্রয়োগ করুন'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotelData {
  final String id, name, location, imageUrl;
  final int price;
  final double rating;
  final int reviews;
  final List<String> amenities;

  const _HotelData({
    required this.id, required this.name, required this.location,
    required this.price, required this.rating, required this.reviews,
    required this.imageUrl, required this.amenities,
  });
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 5),
            Text(label, style: AppTextStyles.labelMd),
          ],
        ),
      ),
    );
  }
}

class _HotelListCard extends StatelessWidget {
  final _HotelData hotel;
  const _HotelListCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hotels/${hotel.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: 115, height: 115,
                child: Image.network(hotel.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(hotel.name, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Available', style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_rounded, size: 12, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Text(hotel.location, style: AppTextStyles.labelSm),
                    ]),
                    const SizedBox(height: 6),
                    StarRating(rating: hotel.rating, reviewCount: hotel.reviews, size: 13),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(text: TextSpan(children: [
                          TextSpan(text: '৳${hotel.price}', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          TextSpan(text: '/রাত', style: AppTextStyles.labelSm),
                        ])),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
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
    );
  }
}

class _HotelGridCard extends StatelessWidget {
  final _HotelData hotel;
  const _HotelGridCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hotels/${hotel.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10)],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(hotel.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.star_rounded, size: 11, color: AppColors.starGold),
                        const SizedBox(width: 3),
                        Text(hotel.rating.toStringAsFixed(1), style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel.name, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(hotel.location, style: AppTextStyles.labelSm),
                  const SizedBox(height: 5),
                  Text('৳${hotel.price}/রাত', style: AppTextStyles.labelLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
