import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';

class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    final activeLanguage = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Premium Icon/Illustration wrapper
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 2.0,
                    ),
                  ),
                  child: Icon(
                    Icons.translate_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
                    .fadeIn(),
                const SizedBox(height: 32),

                // Title
                Text(
                  'ভাষা নির্বাচন করুন\nChoose Language',
                  style: AppTextStyles.headlineMd.copyWith(height: 1.3),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'অ্যাপটি ব্যবহারের জন্য আপনার সুবিধাজনক ভাষা নির্বাচন করুন\nSelect your preferred language to continue',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 40),

                // Bangla Option Card
                _buildLanguageCard(
                  context,
                  ref: ref,
                  lang: AppLanguage.bn,
                  label: 'বাংলা',
                  subtitle: 'Bangla (ডিফল্ট)',
                  flag: '🇧🇩',
                  isSelected: activeLanguage == AppLanguage.bn,
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                const SizedBox(height: 16),

                // English Option Card
                _buildLanguageCard(
                  context,
                  ref: ref,
                  lang: AppLanguage.en,
                  label: 'English',
                  subtitle: 'ইংরেজি (English)',
                  flag: '🇺🇸',
                  isSelected: activeLanguage == AppLanguage.en,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 40),

                // Submit Button
                AppButton(
                  label: activeLanguage == AppLanguage.en ? 'Continue' : 'এগিয়ে যান',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    context.go(AppRoutes.onboarding);
                  },
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required WidgetRef ref,
    required AppLanguage lang,
    required String label,
    required String subtitle,
    required String flag,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLanguage(lang);
      },
      child: AnimatedContainer(
        duration: 250.ms,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.titleLg.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
