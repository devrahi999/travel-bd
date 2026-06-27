import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notif(icon: Icons.check_circle_rounded, color: AppColors.successGreen, title: 'বুকিং নিশ্চিত!', body: 'Long Beach Hotel-এ আপনার বুকিং নিশ্চিত হয়েছে।', time: '২ ঘণ্টা আগে', unread: true),
      _Notif(icon: Icons.auto_awesome_rounded, color: AppColors.primary, title: 'AI Trip Suggestion', body: "এই মাসে Cox's Bazar ভ্রমণের জন্য দারুণ ডিল পাওয়া যাচ্ছে!", time: '৫ ঘণ্টা আগে', unread: true),
      _Notif(icon: Icons.local_offer_rounded, color: AppColors.secondaryContainer, title: '২০% ছাড়!', body: 'Sajek Eco Resort-এ বিশেষ ছাড়। আজই বুক করুন।', time: '১ দিন আগে', unread: false),
      _Notif(icon: Icons.star_rounded, color: AppColors.starGold, title: 'রিভিউ করুন', body: 'আপনার সাম্প্রতিক Cox\'s Bazar ভ্রমণ কেমন ছিল?', time: '২ দিন আগে', unread: false),
      _Notif(icon: Icons.payments_rounded, color: AppColors.infoBlue, title: 'পেমেন্ট সফল', body: '৳9,200 সফলভাবে পেমেন্ট হয়েছে।', time: '৩ দিন আগে', unread: false),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('নোটিফিকেশন', style: AppTextStyles.headlineSm),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {}, child: Text('সব পড়া হয়েছে', style: AppTextStyles.labelLg.copyWith(color: AppColors.primary))),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final n = notifications[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: n.unread ? AppColors.primaryContainer.withValues(alpha: 0.05) : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: n.unread ? AppColors.primaryContainer.withValues(alpha: 0.2) : Colors.transparent),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: n.color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(n.icon, color: n.color, size: 22),
              ),
              title: Text(n.title, style: AppTextStyles.titleMd.copyWith(fontWeight: n.unread ? FontWeight.w700 : FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  Text(n.body, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: 4),
                  Text(n.time, style: AppTextStyles.labelSm),
                ],
              ),
              trailing: n.unread ? Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)) : null,
            ),
          ).animate(delay: (i * 50).ms).fadeIn().slideX(begin: 0.1);
        },
      ),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title, body, time;
  final bool unread;
  const _Notif({required this.icon, required this.color, required this.title, required this.body, required this.time, required this.unread});
}
