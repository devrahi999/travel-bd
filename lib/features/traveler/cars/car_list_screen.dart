import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  String _selectedType = 'সব';
  final List<String> _types = ['সব', 'সেডান', 'SUV', 'মিনিবাস', 'মাইক্রো'];

  final List<_CarData> _cars = [
    const _CarData(id: '1', name: 'Toyota Noah', type: 'মিনিবাস', seats: 7, pricePerDay: 3500, location: "Cox's Bazar", rating: 4.6, ac: true, image: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400'),
    const _CarData(id: '2', name: 'Honda CRV', type: 'SUV', seats: 5, pricePerDay: 4500, location: 'Dhaka', rating: 4.8, ac: true, image: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=400'),
    const _CarData(id: '3', name: 'Toyota Axio', type: 'সেডান', seats: 4, pricePerDay: 2500, location: "Cox's Bazar", rating: 4.4, ac: true, image: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=400'),
    const _CarData(id: '4', name: 'Hyundai H1', type: 'মিনিবাস', seats: 9, pricePerDay: 4000, location: 'Chittagong', rating: 4.5, ac: true, image: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=400'),
  ];

  List<_CarData> get _filtered => _selectedType == 'সব' ? _cars : _cars.where((c) => c.type == _selectedType).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'গাড়ি রেন্টাল', actions: [
        IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _types.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = _types[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedType == _types[i] ? AppColors.primary : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _selectedType == _types[i] ? AppColors.primary : AppColors.outlineVariant),
                    ),
                    child: Text(_types[i], style: AppTextStyles.labelLg.copyWith(
                      color: _selectedType == _types[i] ? AppColors.onPrimary : AppColors.onBackground,
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
                  onTap: () => context.push('/cars/${_filtered[i].id}'),
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
                              height: 160, width: double.infinity,
                              child: Image.network(_filtered[i].image, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.surfaceContainerHigh,
                                    child: Icon(Icons.directions_car_rounded, size: 60, color: AppColors.outline),
                                  )),
                            ),
                            Positioned(
                              top: 10, left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                                child: Text(_filtered[i].type, style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
                              ),
                            ),
                            if (_filtered[i].ac)
                              Positioned(
                                top: 10, right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.infoBlue, borderRadius: BorderRadius.circular(20)),
                                  child: const Text('AC', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
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
                                      const SizedBox(width: 10),
                                      Icon(Icons.people_rounded, size: 12, color: AppColors.onSurfaceVariant),
                                      const SizedBox(width: 3),
                                      Text('${_filtered[i].seats} আসন', style: AppTextStyles.labelSm),
                                    ]),
                                    const SizedBox(height: 4),
                                    StarRating(rating: _filtered[i].rating, size: 13),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('৳${_filtered[i].pricePerDay}', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                                  Text('/দিন', style: AppTextStyles.labelSm),
                                  const SizedBox(height: 6),
                                  ElevatedButton(
                                    onPressed: () => context.push('/cars/${_filtered[i].id}/book'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(80, 32),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      textStyle: AppTextStyles.labelMd,
                                    ),
                                    child: const Text('বুক করুন'),
                                  ),
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

class _CarData {
  final String id, name, type, location, image;
  final int seats, pricePerDay;
  final double rating;
  final bool ac;
  const _CarData({required this.id, required this.name, required this.type, required this.location, required this.seats, required this.pricePerDay, required this.rating, required this.ac, required this.image});
}
