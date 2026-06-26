import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});

  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  String _selectedTag = 'সব';
  final _tags = ['সব', 'বাজেট', 'পরিবার', 'অ্যাডভেঞ্চার', 'রোমান্টিক', 'ইকো'];

  final List<_PackageData> _packages = [
    const _PackageData(id: '1', name: "Cox's Bazar Special", days: 3, price: 8500, includes: ['হোটেল', 'পরিবহন', 'গাইড'], image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400', tag: 'বাজেট', rating: 4.6, bookings: 420),
    const _PackageData(id: '2', name: 'Sajek Adventure', days: 4, price: 12000, includes: ['রিসোর্ট', 'জিপ', 'গাইড', 'খাবার'], image: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400', tag: 'অ্যাডভেঞ্চার', rating: 4.8, bookings: 285),
    const _PackageData(id: '3', name: 'Sundarban Explorer', days: 2, price: 6000, includes: ['লঞ্চ', 'গাইড', 'খাবার'], image: 'https://images.unsplash.com/photo-1606422285050-51a4cdb25c67?w=400', tag: 'ইকো', rating: 4.5, bookings: 190),
    const _PackageData(id: '4', name: 'Family Bangladesh Tour', days: 7, price: 35000, includes: ['হোটেল', 'বাস', 'গাইড', 'খাবার'], image: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=400', tag: 'পরিবার', rating: 4.7, bookings: 120),
    const _PackageData(id: '5', name: 'Honeymoon Package', days: 5, price: 20000, includes: ['রিসোর্ট', 'ক্রুজ', 'খাবার', 'ফুল'], image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400', tag: 'রোমান্টিক', rating: 4.9, bookings: 87),
  ];

  List<_PackageData> get _filtered => _selectedTag == 'সব' ? _packages : _packages.where((p) => p.tag == _selectedTag).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'ট্রাভেল প্যাকেজ'),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tags.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTag = _tags[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedTag == _tags[i] ? AppColors.primary : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _selectedTag == _tags[i] ? AppColors.primary : AppColors.outlineVariant),
                    ),
                    child: Text(_tags[i], style: AppTextStyles.labelLg.copyWith(
                      color: _selectedTag == _tags[i] ? AppColors.onPrimary : AppColors.onBackground,
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
                  onTap: () => context.push('/packages/${_filtered[i].id}'),
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
                        Stack(children: [
                          SizedBox(
                            height: 160, width: double.infinity,
                            child: Image.network(_filtered[i].image, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer)),
                          ),
                          const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.heroGradient), child: SizedBox.expand()),
                          Positioned(
                            top: 10, left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(20)),
                              child: Text(_filtered[i].tag, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSecondaryContainer, fontWeight: FontWeight.w700)),
                            ),
                          ),
                          Positioned(
                            bottom: 10, right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                              child: Text('${_filtered[i].days} দিন', style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(_filtered[i].name, style: AppTextStyles.titleMd)),
                                  StarRating(rating: _filtered[i].rating, size: 13),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Includes
                              Wrap(
                                spacing: 6, runSpacing: 6,
                                children: _filtered[i].includes.map((inc) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(inc, style: AppTextStyles.labelSm.copyWith(color: AppColors.primaryContainer)),
                                )).toList(),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${_filtered[i].bookings}+ বুকিং', style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                                  RichText(text: TextSpan(children: [
                                    TextSpan(text: '৳${_filtered[i].price}', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                                    TextSpan(text: '/জন', style: AppTextStyles.labelSm),
                                  ])),
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

class _PackageData {
  final String id, name, image, tag;
  final int days, price, bookings;
  final List<String> includes;
  final double rating;

  const _PackageData({
    required this.id, required this.name, required this.days, required this.price,
    required this.includes, required this.image, required this.tag, required this.rating,
    required this.bookings,
  });
}
