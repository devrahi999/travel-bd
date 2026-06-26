import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _menuCategories = ['বিশেষ', 'ভাত ও তরকারি', 'বিরিয়ানি', 'সীফুড', 'পানীয়'];
  int _selectedMenu = 0;

  final _menuItems = [
    {'name': 'মাছের তরকারি', 'price': 180, 'tag': 'Best Seller'},
    {'name': 'ভাত', 'price': 40, 'tag': ''},
    {'name': 'ইলিশ ভাজা', 'price': 250, 'tag': 'Special'},
    {'name': 'চিংড়ি মালাই', 'price': 350, 'tag': 'Popular'},
    {'name': 'কাঁকড়া ভুনা', 'price': 400, 'tag': 'Chef\'s Choice'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
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
                  Image.network('https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800', fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer)),
                  const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.heroGradient)),
                  Positioned(
                    bottom: 16, left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ভোজন রসিক', style: AppTextStyles.headlineMd.copyWith(color: Colors.white)),
                        Row(children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text("Cox's Bazar, Chittagong", style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Info bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _InfoBadge(icon: Icons.star_rounded, label: '4.5 রেটিং', color: AppColors.starGold),
                      const SizedBox(width: 10),
                      _InfoBadge(icon: Icons.access_time_rounded, label: '10AM-10PM', color: AppColors.primary),
                      const SizedBox(width: 10),
                      _InfoBadge(icon: Icons.restaurant_menu_rounded, label: 'বাংলা', color: AppColors.secondary),
                    ],
                  ),
                ),

                // Tabs
                TabBar(
                  controller: _tabController,
                  tabs: const [Tab(text: 'মেনু'), Tab(text: 'রিভিউ')],
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  indicatorColor: AppColors.primary,
                ),

                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Menu tab
                      Column(
                        children: [
                          SizedBox(
                            height: 44,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              itemCount: _menuCategories.length,
                              itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedMenu = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: _selectedMenu == i ? AppColors.secondaryContainer : AppColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _selectedMenu == i ? AppColors.secondary : AppColors.outlineVariant),
                                    ),
                                    child: Text(_menuCategories[i], style: AppTextStyles.labelMd.copyWith(
                                      color: _selectedMenu == i ? AppColors.onSecondaryContainer : AppColors.onBackground,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _menuItems.length,
                              itemBuilder: (_, i) {
                                final item = _menuItems[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56, height: 56,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.restaurant_rounded, color: AppColors.secondary, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Text(item['name'] as String, style: AppTextStyles.titleMd),
                                              if ((item['tag'] as String).isNotEmpty) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(item['tag'] as String, style: AppTextStyles.labelSm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
                                                ),
                                              ],
                                            ]),
                                            const SizedBox(height: 4),
                                            Text('৳${item['price']}', style: AppTextStyles.labelLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      // Reviews tab
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text('4.5', style: AppTextStyles.displayLg.copyWith(color: AppColors.primary, fontSize: 48)),
                                const StarRating(rating: 4.5, reviewCount: 220),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...[
                            _buildReview('আরিফ হোসেন', 5, 'খুব ভালো রান্না! ইলিশ ভাজা ছিল অসাধারণ।', '৩ দিন আগে'),
                            _buildReview('সুমাইয়া', 4, 'সী-ফুড আইটেম গুলো ফ্রেশ। দাম একটু বেশি মনে হয়েছে।', '১ সপ্তাহ আগে'),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse('https://wa.me/8801800000000');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          icon: const Icon(Icons.chat_rounded),
          label: const Text('WhatsApp Now'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFF25D366),
          ),
        ),
      ),
    );
  }

  Widget _buildReview(String name, int rating, String comment, String date) {
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
              CircleAvatar(radius: 18, backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
                  child: Text(name[0], style: AppTextStyles.titleMd.copyWith(color: AppColors.secondary))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: AppTextStyles.titleMd),
                Text(date, style: AppTextStyles.labelSm),
              ])),
              Row(children: List.generate(5, (i) => Icon(
                i < rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: AppColors.starGold,
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

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoBadge({required this.icon, required this.label, required this.color});

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
