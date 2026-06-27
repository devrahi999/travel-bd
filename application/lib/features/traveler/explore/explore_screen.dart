import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/app_router.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../core/providers/locale_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  int _selectedCategory = 0;
  final int _selectedDivision = 0;
  String _sortBy = 'জনপ্রিয়তা';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categoriesBn = ['সব', 'সমুদ্র', 'পাহাড়', 'বন', 'ঐতিহাসিক', 'জলপ্রপাত', 'দ্বীপ'];
  final List<String> _categoriesEn = ['All', 'Beach', 'Hills', 'Forest', 'Heritage', 'Waterfall', 'Island'];
  final List<String> _sortOptions = ['জনপ্রিয়তা', 'রেটিং', 'নতুন', 'কাছের'];

  final List<_PlaceData> _places = [
    const _PlaceData(name: "Cox's Bazar", division: 'চট্টগ্রাম', category: 1, rating: 4.8, image: AppConstants.coxBazarImage, description: 'বিশ্বের দীর্ঘতম প্রাকৃতিক সমুদ্র সৈকত'),
    const _PlaceData(name: 'সাজেক ভ্যালি', division: 'রাঙামাটি', category: 2, rating: 4.7, image: AppConstants.sajekImage, description: 'মেঘের রাজ্য সাজেক ভ্যালি'),
    const _PlaceData(name: 'সুন্দরবন', division: 'খুলনা', category: 3, rating: 4.6, image: AppConstants.sundarbanImage, description: 'বিশ্বের বৃহত্তম ম্যানগ্রোভ বন'),
    const _PlaceData(name: 'বান্দরবান', division: 'চট্টগ্রাম', category: 2, rating: 4.5, image: AppConstants.bandarbanImage, description: 'পার্বত্য চট্টগ্রামের প্রাকৃতিক সৌন্দর্য'),
    const _PlaceData(name: 'সেন্ট মার্টিন', division: 'কক্সবাজার', category: 6, rating: 4.9, image: AppConstants.coxBazarImage, description: 'বাংলাদেশের একমাত্র প্রবাল দ্বীপ'),
    const _PlaceData(name: 'রাতারগুল', division: 'সিলেট', category: 3, rating: 4.4, image: AppConstants.sundarbanImage, description: 'মিঠাপানির সোয়াম্প ফরেস্ট'),
    const _PlaceData(name: 'নিঝুম দ্বীপ', division: 'নোয়াখালী', category: 6, rating: 4.3, image: AppConstants.sajekImage, description: 'শান্ত ও নির্জন দ্বীপ'),
    const _PlaceData(name: 'মধুপুর গড়', division: 'ময়মনসিংহ', category: 3, rating: 4.1, image: AppConstants.bandarbanImage, description: 'মধুপুরের সবুজ অরণ্য'),
  ];

  List<_PlaceData> get _filteredPlaces {
    return _places.where((p) {
      bool categoryMatch = _selectedCategory == 0 || p.category == _selectedCategory;
      bool searchMatch = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;
    final categories = isEnglish ? _categoriesEn : _categoriesBn;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(tr('explore_title'), style: AppTextStyles.headlineSm),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: _showFilterSheet,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(115),
              child: Column(
                children: [
                  // Real search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) => setState(() => _searchQuery = val),
                              style: AppTextStyles.bodyMd,
                              decoration: InputDecoration(
                                hintText: tr('explore_search_hint'),
                                hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                                border: InputBorder.none,
                                isDense: false,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: Icon(Icons.close_rounded, size: 18, color: AppColors.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Category chips
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      itemBuilder: (ctx, i) => Padding(
                        padding: EdgeInsets.only(right: i < categories.length - 1 ? 8 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = i),
                          child: AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedCategory == i ? AppColors.primary : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedCategory == i ? AppColors.primary : AppColors.outlineVariant,
                              ),
                            ),
                            child: Text(
                              categories[i],
                              style: AppTextStyles.labelLg.copyWith(
                                color: _selectedCategory == i ? AppColors.onPrimary : AppColors.onBackground,
                                fontWeight: _selectedCategory == i ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
        body: _filteredPlaces.isEmpty
            ? _buildEmpty()
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: _filteredPlaces.length,
                itemBuilder: (ctx, i) {
                  final p = _filteredPlaces[i];
                  return GestureDetector(
                    onTap: () => context.push('/place/$i'),
                    child: _PlaceCard(place: p)
                        .animate(delay: (i * 50).ms)
                        .fadeIn()
                        .scale(begin: const Offset(0.9, 0.9)),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmpty() {
    final tr = ref.read(localeProvider.notifier).translate;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_off_rounded, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(tr('bookings_empty'), style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    final isEnglish = ref.read(localeProvider) == AppLanguage.en;
    GlassTheme.showGlassBottomSheet(
      context: context,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isEnglish ? 'Filter' : 'ফিল্টার', style: AppTextStyles.headlineSm),
          const SizedBox(height: 16),
          Text(isEnglish ? 'By Division' : 'বিভাগ অনুযায়ী', style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: AppConstants.divisions.map((d) => GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Chip(label: Text(d, style: AppTextStyles.labelMd)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text('সাজান', style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _sortOptions.map((s) => ChoiceChip(
              label: Text(s, style: AppTextStyles.labelMd),
              selected: _sortBy == s,
              onSelected: (_) {
                setState(() => _sortBy = s);
                Navigator.pop(ctx);
              },
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PlaceData {
  final String name;
  final String division;
  final int category;
  final double rating;
  final String image;
  final String description;

  const _PlaceData({
    required this.name,
    required this.division,
    required this.category,
    required this.rating,
    required this.image,
    required this.description,
  });
}

class _PlaceCard extends StatelessWidget {
  final _PlaceData place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(place.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.surfaceContainerHigh)),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.outline),
                  ),
                ),
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 11, color: AppColors.starGold),
                        const SizedBox(width: 3),
                        Text(place.rating.toStringAsFixed(1),
                            style: AppTextStyles.labelSm.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 11, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(place.division,
                          style: AppTextStyles.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
