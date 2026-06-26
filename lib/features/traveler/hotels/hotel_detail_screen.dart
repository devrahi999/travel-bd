import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/locale_provider.dart';

class HotelDetailScreen extends ConsumerStatefulWidget {
  final String hotelId;
  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  ConsumerState<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends ConsumerState<HotelDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImage = 0;
  final PageController _imageController = PageController();

  final _images = [
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;

    final roomTypes = [
      {'type': isBn ? 'সিঙ্গেল রুম' : 'Single Room', 'capacity': isBn ? '১ জন' : '1 Person', 'price': 1800, 'available': 3},
      {'type': isBn ? 'ডবল রুম' : 'Double Room', 'capacity': isBn ? '২ জন' : '2 People', 'price': 2800, 'available': 5},
      {'type': isBn ? 'ডিলাক্স রুম' : 'Deluxe Room', 'capacity': isBn ? '২ জন' : '2 People', 'price': 3500, 'available': 2},
      {'type': isBn ? 'সুইট' : 'Suite', 'capacity': isBn ? '৪ জন' : '4 People', 'price': 6500, 'available': 1},
    ];

    final amenities = [
      {'icon': Icons.wifi_rounded, 'label': isBn ? 'ওয়াইফাই' : 'WiFi'},
      {'icon': Icons.ac_unit_rounded, 'label': isBn ? 'এসি' : 'AC'},
      {'icon': Icons.restaurant_rounded, 'label': isBn ? 'রেস্টুরেন্ট' : 'Restaurant'},
      {'icon': Icons.pool_rounded, 'label': isBn ? 'সুইমিং পুল' : 'Pool'},
      {'icon': Icons.local_parking_rounded, 'label': isBn ? 'পার্কিং' : 'Parking'},
      {'icon': Icons.room_service_rounded, 'label': isBn ? 'রুম সার্ভিস' : 'Room Service'},
      {'icon': Icons.spa_rounded, 'label': isBn ? 'স্পা' : 'Spa'},
      {'icon': Icons.fitness_center_rounded, 'label': isBn ? 'জিম' : 'Gym'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 280,
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
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _imageController,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemCount: _images.length,
                    itemBuilder: (_, i) => Image.network(_images[i], fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer)),
                  ),
                  const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.heroGradient)),
                  Positioned(
                    bottom: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: Text('${_currentImage + 1}/${_images.length}', style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel name & info
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Long Beach Hotel', style: AppTextStyles.headlineLgMobile),
                            const SizedBox(height: 6),
                            Row(children: [
                              Icon(Icons.location_on_rounded, size: 16, color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(isBn ? "কক্সবাজার, চট্টগ্রাম" : "Cox's Bazar, Chittagong", style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                            ]),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const StarRating(rating: 4.7, reviewCount: 480),
                          const SizedBox(height: 4),
                          Text('৳3,500${tr('detail_per_night')}', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab bar
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(text: isBn ? 'সুবিধা' : 'Amenities'),
                    Tab(text: isBn ? 'রুম' : 'Rooms'),
                    Tab(text: isBn ? 'রিভিউ' : 'Reviews'),
                  ],
                ),

                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Amenities tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr('detail_about_header'), style: AppTextStyles.headlineSm),
                            const SizedBox(height: 8),
                            Text(
                              isBn
                                  ? 'Long Beach Hotel কক্সবাজারের একটি প্রিমিয়াম বিচ রিসোর্ট। সমুদ্র সৈকত থেকে মাত্র ৫০ মিটার দূরে অবস্থিত। আধুনিক সুযোগ-সুবিধা ও অসাধারণ সেবা নিয়ে আপনার স্বপ্নের ভ্রমণকে বাস্তবে রূপ দিতে আমরা প্রতিশ্রুতিবদ্ধ।'
                                  : 'Long Beach Hotel is a premium beach resort in Cox\'s Bazar, located just 50 meters from the beach. We are committed to turning your dream trip into reality with modern amenities and outstanding service.',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
                            ),
                            const SizedBox(height: 20),
                            Text(isBn ? 'সুবিধাসমূহ' : 'Amenities', style: AppTextStyles.headlineSm),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9,
                              ),
                              itemCount: amenities.length,
                              itemBuilder: (_, i) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(amenities[i]['icon'] as IconData, color: AppColors.primaryContainer, size: 22),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(amenities[i]['label'] as String, style: AppTextStyles.labelSm, textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Location
                            Text(isBn ? 'অবস্থান' : 'Location', style: AppTextStyles.headlineSm),
                            const SizedBox(height: 12),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 32, color: AppColors.primary),
                                  const SizedBox(height: 8),
                                  Text('Cox\'s Bazar Beach Road', style: AppTextStyles.bodyMd),
                                ],
                              )),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.directions_outlined),
                              label: Text(isBn ? 'Google Maps এ দেখুন' : 'View on Google Maps'),
                              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                            ),
                          ],
                        ),
                      ),

                      // Rooms tab
                      ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: roomTypes.length,
                        itemBuilder: (_, i) {
                          final room = roomTypes[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.bed_rounded, color: AppColors.primaryContainer, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(room['type'] as String, style: AppTextStyles.titleMd),
                                      Text('${isBn ? 'ধারণক্ষমতা' : 'Capacity'}: ${room['capacity']}', style: AppTextStyles.labelSm),
                                      Text(isBn ? '${room['available']} টি রুম উপলব্ধ' : '${room['available']} rooms available', style: AppTextStyles.labelSm.copyWith(color: AppColors.successGreen)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('৳${room['price']}', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                                    Text(tr('detail_per_night'), style: AppTextStyles.labelSm),
                                    const SizedBox(height: 6),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final uri = Uri.parse('https://wa.me/8801800000000');
                                        if (await canLaunchUrl(uri)) await launchUrl(uri);
                                      },
                                      icon: const Icon(Icons.chat_rounded, size: 14),
                                      label: const Text('WhatsApp'),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(70, 32),
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        textStyle: AppTextStyles.labelMd,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Reviews tab
                      ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Rating summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text('4.7', style: AppTextStyles.displayLg.copyWith(color: AppColors.primary, fontSize: 48)),
                                    const StarRating(rating: 4.7),
                                    Text(isBn ? '৪৮০ রিভিউ' : '480 Reviews', style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [5, 4, 3, 2, 1].map((r) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          Text('$r', style: AppTextStyles.labelSm),
                                          const SizedBox(width: 6),
                                          Icon(Icons.star_rounded, size: 12, color: AppColors.starGold),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: [0.75, 0.60, 0.20, 0.10, 0.05][5 - r],
                                                backgroundColor: AppColors.surfaceContainerHigh,
                                                color: AppColors.primary,
                                                minHeight: 6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...[
                            _Review(
                              name: isBn ? 'সাইফুল ইসলাম' : 'Saiful Islam',
                              rating: 5,
                              comment: isBn
                                  ? 'অসাধারণ হোটেল! সমুদ্র সৈকতের কাছে, রুম পরিষ্কার, খাবার ভালো।'
                                  : 'Excellent hotel! Close to the beach, clean rooms, good food.',
                              date: isBn ? '৩ দিন আগে' : '3 days ago',
                            ),
                            _Review(
                              name: isBn ? 'নাফিসা রহমান' : 'Nafisa Rahman',
                              rating: 4,
                              comment: isBn
                                  ? 'বেশ ভালো ছিল। রুম সার্ভিস একটু ধীরে ছিল কিন্তু সব মিলিয়ে সন্তুষ্ট।'
                                  : 'Was quite good. Room service was a bit slow, but satisfied overall.',
                              date: isBn ? '১ সপ্তাহ আগে' : '1 week ago',
                            ),
                            _Review(
                              name: isBn ? 'করিম সাহেব' : 'Karim Saheb',
                              rating: 5,
                              comment: isBn
                                  ? 'পরিবার নিয়ে গেছিলাম। সবাই খুশি! আবার যাব ইনশাআল্লাহ।'
                                  : 'Went with family. Everyone was happy! Will go again, InshaAllah.',
                              date: isBn ? '২ সপ্তাহ আগে' : '2 weeks ago',
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Book now bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tr('detail_starts_at'), style: AppTextStyles.labelSm),
                  Text('৳3,500${tr('detail_per_night')}', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Review extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String date;
  const _Review({required this.name, required this.rating, required this.comment, required this.date});

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
              CircleAvatar(radius: 18, backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                  child: Text(name[0], style: AppTextStyles.titleMd.copyWith(color: AppColors.primaryContainer))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: AppTextStyles.titleMd),
                Text(date, style: AppTextStyles.labelSm),
              ])),
              Row(children: List.generate(5, (i) => Icon(
                i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 14, color: AppColors.starGold,
              ))),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5)),
        ],
      ),
    );
  }
}
