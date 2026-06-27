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

class RegisterTravelerScreen extends ConsumerStatefulWidget {
  const RegisterTravelerScreen({super.key});

  @override
  ConsumerState<RegisterTravelerScreen> createState() => _RegisterTravelerScreenState();
}

class _RegisterTravelerScreenState extends ConsumerState<RegisterTravelerScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() async {
    final isEnglish = ref.read(localeProvider) == AppLanguage.en;

    if (_nameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Please fill in all fields' : 'সবগুলো ফিল্ড পূরণ করুন')),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Please agree to terms and conditions' : 'অনুগ্রহ করে শর্তাবলীতে সম্মত হন')),
      );
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Passwords do not match' : 'পাসওয়ার্ড মিলছে না')),
      );
      return;
    }
    final success = await ref.read(authNotifierProvider.notifier).registerTraveler(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (mounted) {
      if (success) {
        _showVerificationDialog();
      } else {
        final error = ref.read(authNotifierProvider).error ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      }
    }
  }

  void _showVerificationDialog() {
    final isEnglish = ref.read(localeProvider) == AppLanguage.en;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mark_email_read_outlined,
              size: 40, color: AppColors.primary),
        ),
        title: Text(isEnglish ? 'Verify Email' : 'ইমেইল যাচাই করুন', style: AppTextStyles.headlineSm),
        content: Text(
          isEnglish
              ? 'A verification link has been sent to your email. Please check your inbox.'
              : 'আপনার ইমেইলে একটি যাচাইকরণ লিঙ্ক পাঠানো হয়েছে। অনুগ্রহ করে ইমেইল চেক করুন।',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              },
              child: Text(isEnglish ? 'OK' : 'ঠিক আছে'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => context.go(AppRoutes.login),
                  ),
                  const Spacer(),
                  Text(
                    isEnglish ? 'New Account' : 'নতুন অ্যাকাউন্ট',
                    style: AppTextStyles.headlineSm,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero text
                    Text(
                      isEnglish ? 'Join as a\nTraveler! 🌍' : 'ট্রাভেলার হিসেবে\nযোগ দিন! 🌍',
                      style: AppTextStyles.headlineLgMobile.copyWith(
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3),

                    const SizedBox(height: 8),

                    Text(
                      isEnglish ? 'Get the best experience traveling Bangladesh' : 'বাংলাদেশ ভ্রমণের সেরা অভিজ্ঞতা নিন',
                      style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 32),

                    // Name
                    _buildLabel(isEnglish ? 'Full Name' : 'পূর্ণ নাম'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: isEnglish ? 'Enter your name' : 'আপনার নাম লিখুন',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    ).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 16),

                    // Email
                    _buildLabel(isEnglish ? 'Email' : 'ইমেইল'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'example@email.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 16),

                    // Password
                    _buildLabel(isEnglish ? 'Password' : 'পাসওয়ার্ড'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        hintText: isEnglish ? 'Min. 8 characters' : 'কমপক্ষে ৮ অক্ষর',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePass
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ).animate().fadeIn(delay: 250.ms),

                    const SizedBox(height: 16),

                    // Confirm Password
                    _buildLabel(isEnglish ? 'Confirm Password' : 'পাসওয়ার্ড নিশ্চিত করুন'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        hintText: isEnglish ? 'Re-enter password' : 'পাসওয়ার্ড পুনরায় লিখুন',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 20),

                    // Terms
                    GestureDetector(
                      onTap: () =>
                          setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: 200.ms,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _agreedToTerms
                                  ? AppColors.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: _agreedToTerms
                                    ? AppColors.primary
                                    : AppColors.outline,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: _agreedToTerms
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: isEnglish ? 'I agree to ' : 'আমি ',
                                style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: isEnglish ? ' and ' : ' এবং ',
                                    style: AppTextStyles.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!isEnglish)
                                    TextSpan(
                                      text: ' এ সম্মত',
                                      style: AppTextStyles.bodyMd.copyWith(
                                          color: AppColors.onSurfaceVariant),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms),

                    const SizedBox(height: 28),

                    // Register button
                    AppButton(
                      label: isEnglish ? 'Register' : 'রেজিস্ট্রেশন করুন',
                      icon: Icons.person_add_rounded,
                      isLoading: ref.watch(authNotifierProvider).isLoading,
                      onPressed: _register,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: RichText(
                          text: TextSpan(
                            text: isEnglish ? 'Already have an account? ' : 'ইতোমধ্যে অ্যাকাউন্ট আছে? ',
                            style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant),
                            children: [
                              TextSpan(
                                text: tr('login_sign_in'),
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 450.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelLg.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
