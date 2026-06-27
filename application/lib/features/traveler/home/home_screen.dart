import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/destination_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/theme/glass_theme.dart';
import '../../../core/providers/locale_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String tr(String key) => ref.read(localeProvider.notifier).translate(key);

  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;
  int _bannerIndex = 0;
  final PageController _bannerController = PageController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _currentLocation = 'Dhaka, Bangladesh';
  String _weatherTemp = '28°C';
  IconData _weatherIcon = Icons.wb_sunny_rounded;

  final List<_BannerData> _banners = const [
    _BannerData(
      title: "Cox's Bazar Beach",
      subtitle: 'বিশ্বের দীর্ঘতম সমুদ্র সৈকত',
      location: 'চট্টগ্রাম, বাংলাদেশ',
      imageUrl: AppConstants.coxBazarImage,
      tag: 'Featured',
    ),
    _BannerData(
      title: 'সাজেক ভ্যালি',
      subtitle: 'মেঘের রাজ্যে হারিয়ে যান',
      location: 'রাঙামাটি, বাংলাদেশ',
      imageUrl: AppConstants.sajekImage,
      tag: 'Trending',
    ),
    _BannerData(
      title: 'সুন্দরবন',
      subtitle: 'বিশ্বের বৃহত্তম ম্যানগ্রোভ বন',
      location: 'খুলনা, বাংলাদেশ',
      imageUrl: AppConstants.sundarbanImage,
      tag: 'Popular',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _scrollController.addListener(() {
      setState(() {
        _isHeaderCollapsed = _scrollController.offset > 80;
      });
    });
    // Auto-scroll banner
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    final next = (_bannerIndex + 1) % _banners.length;
    _bannerController.animateToPage(
      next,
      duration: 600.ms,
      curve: Curves.easeInOutCubic,
    );
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      Position position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 5));
      
      try {
        final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m,weather_code');
        final response = await http.get(url).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final temp = data['current']['temperature_2m'];
          final code = data['current']['weather_code'];
          if (mounted) {
            setState(() {
              _weatherTemp = '${temp.round()}°C';
              _weatherIcon = (code <= 3) ? Icons.wb_sunny_rounded : Icons.cloud_rounded;
            });
          }
        }
      } catch (e) {
        // Ignore weather fetch error
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        if (mounted) {
          setState(() {
            _currentLocation = placemarks[0].locality ?? placemarks[0].administrativeArea ?? 'Dhaka, Bangladesh';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _currentLocation = 'Dhaka, Bangladesh');
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sticky header
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryContainer,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroHeader(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 1,
                color: Colors.transparent,
              ),
            ),
            actions: [
              IconButton(
                icon: const Badge(
                  label: Text('3'),
                  child: Icon(Icons.notifications_outlined,
                      color: Colors.white),
                ),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Travel BD',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),

          // Location, Weather and Search Bar Area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.pageHorizontalPadding, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location and Weather
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            _currentLocation,
                            style: AppTextStyles.titleMd.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(_weatherIcon, color: Colors.orange, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            _weatherTemp,
                            style: AppTextStyles.titleMd.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // New Redesigned Solid Search Bar
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: AppColors.onSurfaceVariant, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            style: AppTextStyles.titleMd,
                            decoration: InputDecoration(
                              hintText: tr('home_search_hint'),
                              hintStyle: AppTextStyles.titleMd.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _searchFocusNode.unfocus();
                              setState(() => _searchQuery = '');
                            },
                            child: Icon(Icons.close_rounded, size: 20, color: AppColors.onSurfaceVariant),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.tune_rounded, color: AppColors.onPrimaryContainer, size: 18),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_searchQuery.isNotEmpty)
            ...(() {
              // Rich Mock Data (Since DB is empty)
              final List<Map<String, dynamic>> allItems = [
                {'name': "Cox's Bazar Beach", 'type': 'Destination', 'rating': 4.8, 'reviews': 12500},
                {'name': "Long Beach Hotel", 'type': 'Hotel', 'rating': 4.7, 'reviews': 3200},
                {'name': "Ocean Paradise", 'type': 'Hotel', 'rating': 4.9, 'reviews': 4500},
                {'name': "Sylhet Tea Gardens", 'type': 'Destination', 'rating': 4.6, 'reviews': 8900},
                {'name': "Grand Sylhet Hotel", 'type': 'Hotel', 'rating': 4.5, 'reviews': 1100},
                {'name': "Sundarbans Mangrove", 'type': 'Destination', 'rating': 4.9, 'reviews': 15600},
                {'name': "St. Martin's Island", 'type': 'Destination', 'rating': 4.8, 'reviews': 9800},
                {'name': "Sajek Valley", 'type': 'Destination', 'rating': 4.7, 'reviews': 7600},
                {'name': "Sajek Resort", 'type': 'Hotel', 'rating': 4.3, 'reviews': 800},
              ];

              // Filter by query
              var results = allItems.where((item) => 
                (item['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
              
              // Sort by rating (desc) then reviews (desc)
              results.sort((a, b) {
                int ratingComp = (b['rating'] as double).compareTo(a['rating'] as double);
                if (ratingComp != 0) return ratingComp;
                return (b['reviews'] as int).compareTo(a['reviews'] as int);
              });
              
              return [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.pageHorizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (results.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Icon(Icons.search_off_rounded, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                                const SizedBox(height: 12),
                                Text("কোনো ফলাফল পাওয়া যায়নি", style: AppTextStyles.titleMd.copyWith(color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          );
                        }
                        final item = results[index];
                        final isHotel = item['type'] == 'Hotel';
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (isHotel ? AppColors.infoBlue : AppColors.primary).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isHotel ? Icons.hotel_rounded : Icons.location_on_rounded, 
                                color: isHotel ? AppColors.infoBlue : AppColors.primary
                              ),
                            ),
                            title: Text(item['name'], style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded, color: AppColors.starGold, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item['rating']} (${item['reviews']} reviews)',
                                    style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(item['type'], style: AppTextStyles.labelSm),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () {
                              _searchFocusNode.unfocus();
                              context.push(AppRoutes.explore);
                            },
                          ),
                        );
                      },
                      childCount: results.isEmpty ? 1 : results.length,
                    ),
                  ),
                )
              ];
            }())
          else
            // Main content
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Featured Banner
                  _buildFeaturedBanner(),

                const SizedBox(height: AppConstants.spacingXl),

                // Quick actions
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: _buildQuickActions(),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Popular destinations
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: SectionHeader(
                    title: tr('home_popular_dest'),
                    actionLabel: tr('see_all'),
                    onAction: () => context.go(AppRoutes.explore),
                  ),
                ),
                const SizedBox(height: 12),
                _buildPopularDestinations(),

                const SizedBox(height: AppConstants.spacingXl),


                // AI suggestion strip
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: _buildAiSuggestionStrip(),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Top rated hotels
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: SectionHeader(
                    title: tr('home_top_hotels'),
                    actionLabel: tr('see_all'),
                    onAction: () => context.go(AppRoutes.hotelList),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTopHotels(),

                const SizedBox(height: AppConstants.spacingXl),

                // Restaurants nearby
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: SectionHeader(
                    title: tr('home_nearby_restaurants'),
                    actionLabel: tr('see_all'),
                    onAction: () => context.go(AppRoutes.restaurantList),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNearbyRestaurants(),

                const SizedBox(height: AppConstants.spacingXl),

                // Travel packages
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.pageHorizontalPadding),
                  child: SectionHeader(
                    title: tr('home_travel_packages'),
                    actionLabel: tr('see_all'),
                    onAction: () => context.go(AppRoutes.packageList),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTravelPackages(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryContainer, AppColors.primary],
        ),
      ),
      child: Stack(
        children: [
          // Decorative
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.15),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 64, 60, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('home_greeting'),
                    style: AppTextStyles.headlineLgMobile.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pageHorizontalPadding),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemCount: _banners.length,
                itemBuilder: (ctx, i) => _BannerCard(data: _banners[i]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: 300.ms,
                width: _bannerIndex == i ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _bannerIndex == i
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final tr = ref.watch(localeProvider.notifier).translate;
    final actions = [
      {'icon': Icons.hotel_rounded, 'label': tr('home_quick_hotels'), 'route': AppRoutes.hotelList},
      {'icon': Icons.person_pin_circle_rounded, 'label': tr('home_quick_guides'), 'route': AppRoutes.guideList},
      {'icon': Icons.luggage_rounded, 'label': tr('home_quick_packages'), 'route': AppRoutes.packageList},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('home_what_looking'), style: AppTextStyles.headlineSm),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            actions.length,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => context.push(actions[i]['route'] as String),
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          actions[i]['icon'] as IconData,
                          color: AppColors.primaryContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actions[i]['label'] as String,
                        style: AppTextStyles.labelMd,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 80).ms).fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    return SizedBox(
      height: 226,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pageHorizontalPadding),
        itemCount: AppConstants.popularDestinations.length,
        itemBuilder: (ctx, i) {
          final dest = AppConstants.popularDestinations[i];
          final imageUrls = [
            AppConstants.coxBazarImage,
            AppConstants.sundarbanImage,
            AppConstants.sajekImage,
            AppConstants.bandarbanImage,
            AppConstants.coxBazarImage,
            AppConstants.sajekImage,
          ];
          return Padding(
            padding: EdgeInsets.only(right: i < 5 ? 12 : 0),
            child: DestinationCard(
              name: dest['name']!,
              location: dest['division']!,
              imageUrl: imageUrls[i % imageUrls.length],
              rating: 4.2 + (i * 0.1),
              onTap: () => context.push('/place/$i'),
            ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.3),
          );
        },
      ),
    );
  }

  Widget _buildAiSuggestionStrip() {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.aiPlanner),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF03160C), Color(0xFF0B261A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF16A257).withValues(alpha: 0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A257).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: Color(0xFFFFC107), size: 20)
             .animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15), duration: 1500.ms, curve: Curves.easeInOut),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr('home_ai_confused'),
                    style: AppTextStyles.titleMd.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tr('home_ai_desc'),
                    style: AppTextStyles.bodySm.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9E24), Color(0xFFFF5C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5C00).withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    tr('home_ai_btn'),
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .shimmer(delay: 3000.ms, duration: 1800.ms),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildTopHotels() {
    final hotels = [
      {'name': 'Long Beach Hotel', 'location': 'কক্সবাজার', 'price': 3500, 'rating': 4.7},
      {'name': 'Sea Pearl Beach', 'location': 'কক্সবাজার', 'price': 5000, 'rating': 4.8},
      {'name': 'Sajek Resort', 'location': 'রাঙামাটি', 'price': 2800, 'rating': 4.5},
    ];

    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pageHorizontalPadding),
        itemCount: hotels.length,
        itemBuilder: (ctx, i) {
          final h = hotels[i];
          return Padding(
            padding: EdgeInsets.only(right: i < hotels.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => context.push('/hotels/$i'),
              child: Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.hotel_rounded,
                              color: AppColors.primaryContainer, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(h['name'] as String,
                                  style: AppTextStyles.titleMd,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(h['location'] as String,
                                  style: AppTextStyles.labelSm),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StarRating(rating: (h['rating'] as num).toDouble()),
                        Text(
                          '৳${h['price']}/রাত',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate(delay: (i * 60).ms).fadeIn(),
          );
        },
      ),
    );
  }

  Widget _buildNearbyRestaurants() {
    final restaurants = [
      {'name': 'ভোজন রসিক', 'cuisine': 'বাংলা', 'rating': 4.5, 'price': 300},
      {'name': 'Dragon Palace', 'cuisine': 'চাইনিজ', 'rating': 4.3, 'price': 450},
      {'name': 'Mermaid Café', 'cuisine': 'সীফুড', 'rating': 4.6, 'price': 600},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pageHorizontalPadding),
        itemCount: restaurants.length,
        itemBuilder: (ctx, i) {
          final r = restaurants[i];
          return Padding(
            padding: EdgeInsets.only(right: i < restaurants.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => context.push('/restaurants/$i'),
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.restaurant_rounded,
                              color: AppColors.secondary, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(r['name'] as String,
                              style: AppTextStyles.titleMd,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(r['cuisine'] as String,
                        style: AppTextStyles.labelSm),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StarRating(rating: (r['rating'] as num).toDouble(), size: 12),
                        Text(
                          '৳${r['price']}/জন',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTravelPackages() {
    final packages = [
      {'name': 'Cox\'s Bazar Special', 'days': 3, 'price': 8500, 'tag': 'Budget'},
      {'name': 'Sajek Adventure', 'days': 4, 'price': 12000, 'tag': 'Popular'},
      {'name': 'Sundarban Explorer', 'days': 2, 'price': 6000, 'tag': 'Eco'},
    ];

    return SizedBox(
      height: 155,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pageHorizontalPadding),
        itemCount: packages.length,
        itemBuilder: (ctx, i) {
          final p = packages[i];
          return Padding(
            padding: EdgeInsets.only(right: i < packages.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => context.push('/packages/$i'),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surfaceContainerLowest,
                      AppColors.surfaceContainerLow,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p['tag'] as String,
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${p['days']} দিন',
                          style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p['name'] as String,
                      style: AppTextStyles.titleMd,
                      maxLines: 2,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.hotel_rounded,
                            size: 14, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Icon(Icons.directions_bus_rounded,
                            size: 14, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Icon(Icons.person_pin_rounded,
                            size: 14, color: AppColors.onSurfaceVariant),
                        const Spacer(),
                        Text(
                          '৳${p['price']}',
                          style: AppTextStyles.titleMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final String location;
  final String imageUrl;
  final String tag;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.imageUrl,
    required this.tag,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(data.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
            Container(color: AppColors.primaryContainer)),
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.heroGradient),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.tag,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(data.title,
                  style: AppTextStyles.headlineMd.copyWith(color: Colors.white)),
              Text(data.subtitle,
                  style: AppTextStyles.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(data.location,
                      style: AppTextStyles.labelMd.copyWith(
                          color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
