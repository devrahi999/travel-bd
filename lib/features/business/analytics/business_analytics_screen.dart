import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class BusinessAnalyticsScreen extends StatefulWidget {
  const BusinessAnalyticsScreen({super.key});

  @override
  State<BusinessAnalyticsScreen> createState() => _BusinessAnalyticsScreenState();
}

class _BusinessAnalyticsScreenState extends State<BusinessAnalyticsScreen> {
  String _period = 'এই মাস';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Analytics'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Row(
              children: [
                Expanded(child: Text('পারফর্মেন্স রিপোর্ট', style: AppTextStyles.headlineSm)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.outlineVariant),
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surfaceContainerLowest,
                  ),
                  child: DropdownButton<String>(
                    value: _period,
                    underline: const SizedBox(),
                    style: AppTextStyles.labelLg,
                    items: ['এই সপ্তাহ', 'এই মাস', 'এই বছর'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setState(() => _period = v!),
                  ),
                ),
              ],
            ).animate().fadeIn(),

            const SizedBox(height: 20),

            // Key metrics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _MetricCard(title: 'মোট আয়', value: '৳3,24,000', growth: '+15.2%', icon: Icons.payments_rounded, color: AppColors.successGreen).animate(delay: 50.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                _MetricCard(title: 'মোট বুকিং', value: '287', growth: '+12.4%', icon: Icons.confirmation_number_rounded, color: AppColors.primary).animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                _MetricCard(title: 'গড় রেটিং', value: '4.7', growth: '+0.2', icon: Icons.star_rounded, color: AppColors.starGold).animate(delay: 150.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                _MetricCard(title: 'ক্যান্সেলেশন', value: '5%', growth: '-2.1%', icon: Icons.cancel_outlined, color: AppColors.error, growthNegative: true).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
              ],
            ),

            const SizedBox(height: 24),

            // Revenue bar chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('সাপ্তাহিক আয়', style: AppTextStyles.titleMd),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      {'day': 'সো', 'val': 0.5},
                      {'day': 'মঙ্', 'val': 0.7},
                      {'day': 'বু', 'val': 0.4},
                      {'day': 'বৃ', 'val': 0.9},
                      {'day': 'শু', 'val': 1.0},
                      {'day': 'শ', 'val': 0.8},
                      {'day': 'রো', 'val': 0.6},
                    ].map((d) => Column(children: [
                      Text('৳${((d['val'] as double) * 15000).round()}', style: AppTextStyles.labelSm.copyWith(fontSize: 8, color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 80 * (d['val'] as double),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(d['day'] as String, style: AppTextStyles.labelSm),
                    ])).toList(),
                  ),
                ],
              ),
            ).animate(delay: 250.ms).fadeIn(),

            const SizedBox(height: 20),

            // Room type breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('রুম টাইপ অনুযায়ী বুকিং', style: AppTextStyles.titleMd),
                  const SizedBox(height: 16),
                  ...[
                    {'type': 'ডবল রুম', 'pct': 0.45, 'count': 129, 'color': AppColors.primary},
                    {'type': 'সিঙ্গেল রুম', 'pct': 0.25, 'count': 72, 'color': AppColors.secondary},
                    {'type': 'ডিলাক্স', 'pct': 0.20, 'count': 57, 'color': AppColors.infoBlue},
                    {'type': 'সুইট', 'pct': 0.10, 'count': 29, 'color': AppColors.starGold},
                  ].map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: r['color'] as Color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(r['type'] as String, style: AppTextStyles.bodyMd)),
                        Text('${r['count']} বুকিং', style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(width: 8),
                        Text('${((r['pct'] as double) * 100).round()}%', style: AppTextStyles.labelMd.copyWith(color: r['color'] as Color, fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: r['pct'] as double,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          color: r['color'] as Color,
                          minHeight: 6,
                        ),
                      ),
                    ]),
                  )),
                ],
              ),
            ).animate(delay: 300.ms).fadeIn(),

            const SizedBox(height: 20),

            // Top performers
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('সেরা মাস', style: AppTextStyles.titleMd),
                  const SizedBox(height: 12),
                  ...[
                    {'month': 'ডিসেম্বর', 'amount': '৳65,400', 'pct': 0.95},
                    {'month': 'নভেম্বর', 'amount': '৳58,200', 'pct': 0.80},
                    {'month': 'অক্টোবর', 'amount': '৳52,100', 'pct': 0.72},
                  ].map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Expanded(child: Text(m['month'] as String, style: AppTextStyles.bodyMd)),
                      Text(m['amount'] as String, style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      SizedBox(width: 80, child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: m['pct'] as double, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 6),
                      )),
                    ]),
                  )),
                ],
              ),
            ).animate(delay: 350.ms).fadeIn(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title, value, growth;
  final IconData icon;
  final Color color;
  final bool growthNegative;

  const _MetricCard({required this.title, required this.value, required this.growth, required this.icon, required this.color, this.growthNegative = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 20),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: (growthNegative ? AppColors.successGreen : color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(growth, style: AppTextStyles.labelSm.copyWith(
                color: growthNegative ? AppColors.successGreen : color,
                fontWeight: FontWeight.w700,
              )),
            ),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: AppTextStyles.headlineSm.copyWith(color: color, fontWeight: FontWeight.w700)),
            Text(title, style: AppTextStyles.labelSm),
          ]),
        ],
      ),
    );
  }
}
