import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  int _selectedCuisine = 0;
  final List<String> _cuisines = ['সব', 'বাংলা', 'চাইনিজ', 'সীফুড', 'ইন্ডিয়ান', 'ফাস্ট ফুড'];

  final List<_RestData> _restaurants = [
    const _RestData(id: '1', name: 'ভোজন রসিক', cuisine: 'বাংলা', location: 'কক্সবাজার', rating: 4.5, priceForTwo: 400, isOpen: true, imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400'),
    const _RestData(id: '2', name: 'Dragon Palace', cuisine: 'চাইনিজ', location: 'কক্সবাজার', rating: 4.3, priceForTwo: 600, isOpen: true, imageUrl: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400'),
    const _RestData(id: '3', name: 'Mermaid Café', cuisine: 'সীফুড', location: 'কক্সবাজার', rating: 4.7, priceForTwo: 800, isOpen: false, imageUrl: 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=400'),
    const _RestData(id: '4', name: 'Spice Garden', cuisine: 'ইন্ডিয়ান', location: 'ঢাকা', rating: 4.4, priceForTwo: 700, isOpen: true, imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400'),
    const _RestData(id: '5', name: 'Tiger Den', cuisine: 'বাংলা', location: 'খুলনা', rating: 4.2, priceForTwo: 350, isOpen: true, imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400'),
  ];

  List<_RestData> get _filtered => _selectedCuisine == 0
      ? _restaurants
      : _restaurants.where((r) => r.cuisine == _cuisines[_selectedCuisine]).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'রেস্টুরেন্ট', actions: [
        IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _cuisines.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCuisine = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCuisine == i ? AppColors.primary : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _selectedCuisine == i ? AppColors.primary : AppColors.outlineVariant),
                    ),
                    child: Text(_cuisines[i], style: AppTextStyles.labelLg.copyWith(
                      color: _selectedCuisine == i ? AppColors.onPrimary : AppColors.onBackground,
                    )),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => context.push('/restaurants/${_filtered[i].id}'),
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
                        Stack(
                          children: [
                            SizedBox(
                              height: 160,
                              width: double.infinity,
                              child: Image.network(_filtered[i].imageUrl, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
                            ),
                            Positioned(
                              top: 10, right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _filtered[i].isOpen ? AppColors.successGreen : AppColors.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _filtered[i].isOpen ? 'খোলা' : 'বন্ধ',
                                  style: AppTextStyles.labelSm.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10, left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                                child: Text(_filtered[i].cuisine, style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_filtered[i].name, style: AppTextStyles.titleMd),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Icon(Icons.location_on_rounded, size: 12, color: AppColors.onSurfaceVariant),
                                      const SizedBox(width: 3),
                                      Text(_filtered[i].location, style: AppTextStyles.labelSm),
                                    ]),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  StarRating(rating: _filtered[i].rating, size: 13),
                                  const SizedBox(height: 4),
                                  Text('৳${_filtered[i].priceForTwo}/দুইজন', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _RestData {
  final String id, name, cuisine, location, imageUrl;
  final double rating;
  final int priceForTwo;
  final bool isOpen;
  const _RestData({required this.id, required this.name, required this.cuisine, required this.location, required this.rating, required this.priceForTwo, required this.isOpen, required this.imageUrl});
}
