import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

// Simple placeholder screens for car detail and booking

class CarDetailScreen extends StatelessWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'গাড়ির বিবরণ'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceContainerHigh,
                  child: Icon(Icons.directions_car_rounded, size: 80, color: AppColors.outline),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Toyota Noah', style: AppTextStyles.headlineLgMobile)),
                      const StarRating(rating: 4.6),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.location_on_rounded, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text("Cox's Bazar", style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                  ]),
                  const SizedBox(height: 16),
                  // Feature grid
                  const _FeatureGrid(features: [
                    {'icon': Icons.people_rounded, 'label': '৭ আসন'},
                    {'icon': Icons.ac_unit_rounded, 'label': 'AC'},
                    {'icon': Icons.local_gas_station_rounded, 'label': 'ডিজেল'},
                    {'icon': Icons.settings_rounded, 'label': 'অটোমেটিক'},
                  ]),
                  const SizedBox(height: 20),
                  Text('বিবরণ', style: AppTextStyles.headlineSm),
                  const SizedBox(height: 8),
                  Text(
                    'Toyota Noah একটি আধুনিক মিনিবাস যা বড় পরিবার বা গ্রুপ ভ্রমণের জন্য আদর্শ। পরিষ্কার, AC সহ, এবং সৌন্দর্য মনোরম পরিবেশে সেবা প্রদান করে।',
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.7),
                  ),
                  const SizedBox(height: 20),
                  Text('ভাড়ার শর্তাবলী', style: AppTextStyles.headlineSm),
                  const SizedBox(height: 8),
                  ...[
                    'ড্রাইভার ভাড়ার সাথে অন্তর্ভুক্ত',
                    'জ্বালানি খরচ আলাদা',
                    'মিনিমাম ১ দিন',
                    'বাতিলের জন্য ২৪ ঘণ্টা আগে জানাতে হবে',
                  ].map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(t, style: AppTextStyles.bodyMd),
                    ]),
                  )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('শুরু হয়', style: AppTextStyles.labelSm),
                Text('৳3,500/দিন', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
              ],
            )),
            Expanded(flex: 2, child: ElevatedButton.icon(
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
            )),
          ],
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<Map<String, dynamic>> features;
  const _FeatureGrid({required this.features});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.9,
      ),
      itemCount: features.length,
      itemBuilder: (_, i) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(features[i]['icon'] as IconData, color: AppColors.primaryContainer, size: 22),
          ),
          const SizedBox(height: 4),
          Text(features[i]['label'] as String, style: AppTextStyles.labelSm, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
