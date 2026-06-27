import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }
    await ref.read(authNotifierProvider.notifier).sendPasswordReset(email);
    if (mounted) setState(() => _emailSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.onBackground),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.lock_reset_rounded, size: 40, color: AppColors.primary),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),

              Text(
                isEnglish ? 'Forgot Password?' : 'পাসওয়ার্ড ভুলে গেছেন?',
                style: AppTextStyles.headlineMd,
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 12),
              Text(
                isEnglish
                    ? 'Enter your email and we\'ll send you a link to reset your password.'
                    : 'আপনার ইমেইল দিন। আমরা পাসওয়ার্ড রিসেটের লিংক পাঠাবো।',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 40),

              if (!_emailSent) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: isEnglish ? 'Your email address' : 'আপনার ইমেইল ঠিকানা',
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 24),
                AppButton(
                  label: isEnglish ? 'Send Reset Link' : 'রিসেট লিংক পাঠান',
                  icon: Icons.send_rounded,
                  isLoading: authState.isLoading,
                  onPressed: _sendReset,
                ).animate().fadeIn(delay: 300.ms),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        isEnglish ? 'Email Sent!' : 'ইমেইল পাঠানো হয়েছে!',
                        style: AppTextStyles.titleLg.copyWith(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEnglish
                            ? 'Check your inbox for a password reset link. Check spam if you don\'t see it.'
                            : 'আপনার ইনবক্স চেক করুন। না পেলে স্প্যাম ফোল্ডারটিও দেখুন।',
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
                const SizedBox(height: 24),
                AppButton(
                  label: isEnglish ? 'Back to Login' : 'লগইনে ফিরুন',
                  icon: Icons.login_rounded,
                  onPressed: () => context.go(AppRoutes.login),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
