import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class GuideListScreen extends StatefulWidget {
  const GuideListScreen({super.key});

  @override
  State<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends State<GuideListScreen> {
  final List<_GuideData> _guides = [
    const _GuideData(id: '1', name: 'করিম উদ্দিন', location: "Cox's Bazar", languages: ['বাংলা', 'English'], rating: 4.8, reviews: 124, pricePerDay: 1500, imageUrl: '', experience: 5, speciality: 'সমুদ্র সৈকত'),
    const _GuideData(id: '2', name: 'রাহুল দে', location: 'বান্দরবান', languages: ['বাংলা', 'English', 'হিন্দি'], rating: 4.7, reviews: 89, pricePerDay: 1800, imageUrl: '', experience: 7, speciality: 'পাহাড়ি ট্রেক'),
    const _GuideData(id: '3', name: 'মনির হোসেন', location: 'সুন্দরবন', languages: ['বাংলা'], rating: 4.6, reviews: 67, pricePerDay: 2000, imageUrl: '', experience: 10, speciality: 'সুন্দরবন সাফারি'),
    const _GuideData(id: '4', name: 'তানিয়া সুলতানা', location: 'সিলেট', languages: ['বাংলা', 'English'], rating: 4.9, reviews: 210, pricePerDay: 1600, imageUrl: '', experience: 6, speciality: 'চা বাগান'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'ট্যুর গাইড', actions: [
        IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
      ]),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _guides.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => context.push('/guides/${_guides[i].id}'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.15),
                    child: Text(
                      _guides[i].name[0],
                      style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primaryContainer),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(_guides[i].name, style: AppTextStyles.titleMd)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Verified ✓', style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.location_on_rounded, size: 12, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text(_guides[i].location, style: AppTextStyles.labelSm),
                          const SizedBox(width: 10),
                          Icon(Icons.work_rounded, size: 12, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text('${_guides[i].experience} বছর', style: AppTextStyles.labelSm),
                        ]),
                        const SizedBox(height: 6),
                        Text('বিশেষত্ব: ${_guides[i].speciality}', style: AppTextStyles.labelMd.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        // Languages
                        Wrap(
                          spacing: 4,
                          children: _guides[i].languages.map((l) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.outlineVariant),
                            ),
                            child: Text(l, style: AppTextStyles.labelSm),
                          )).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StarRating(rating: _guides[i].rating, reviewCount: _guides[i].reviews, size: 13),
                            Text('৳${_guides[i].pricePerDay}/দিন', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
    );
  }
}

class _GuideData {
  final String id, name, location, imageUrl, speciality;
  final List<String> languages;
  final double rating;
  final int reviews, pricePerDay, experience;

  const _GuideData({
    required this.id, required this.name, required this.location,
    required this.languages, required this.rating, required this.reviews,
    required this.pricePerDay, required this.imageUrl, required this.experience,
    required this.speciality,
  });
}
