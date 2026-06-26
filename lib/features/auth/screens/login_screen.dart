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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final isEnglish = ref.read(localeProvider) == AppLanguage.en;
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Please enter email and password' : 'ইমেইল এবং পাসওয়ার্ড দিন')),
      );
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;
    if (success) {
      final user = ref.read(authServiceProvider).isLoggedIn;
      if (user) {
        final role = await ref.read(authServiceProvider).getUserRole();
        if (!mounted) return;
        if (role == 'business') {
          context.go(AppRoutes.businessDashboard);
        } else {
          context.go(AppRoutes.home);
        }
      }
    } else {
      final error = ref.read(authNotifierProvider).error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
      );
    }
  }

  void _googleSignIn() async {
    final success = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    if (success) {
      final role = await ref.read(authServiceProvider).getUserRole();
      if (!mounted) return;
      if (role == 'business') {
        context.go(AppRoutes.businessDashboard);
      } else {
        context.go(AppRoutes.home);
      }
    } else {
      final error = ref.read(authNotifierProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Top hero section (35%)
            Flexible(
              flex: 35,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryFixed, AppColors.background],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -60,
                      left: -60,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: -30,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryFixed.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 20),
                          child: TextButton.icon(
                            onPressed: () => context.go(AppRoutes.registerBusiness),
                            icon: const Icon(Icons.store_outlined, size: 16),
                            label: Text(tr('login_is_business')),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Icon(Icons.flight_takeoff_rounded, size: 44, color: AppColors.primary),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Travel BD',
                            style: AppTextStyles.headlineLg.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom form section (65%)
            Flexible(
              flex: 65,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, -8))],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('login_welcome'),
                        style: AppTextStyles.headlineLgMobile.copyWith(color: const Color(0xFF1A1A2E)),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
                      const SizedBox(height: 6),
                      Text(
                        tr('login_sub'),
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      ).animate().fadeIn(delay: 150.ms),
                      const SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                        decoration: InputDecoration(
                          hintText: tr('login_email_hint'),
                          prefixIcon: const Icon(Icons.mail_outline_rounded),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                        decoration: InputDecoration(
                          hintText: tr('login_pass_hint'),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.outline,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),

                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.forgotPassword),
                          child: Text(
                            tr('login_forgot'),
                            style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 8),

                      // Login button
                      AppButton(
                        label: tr('login_sign_in'),
                        icon: Icons.login_rounded,
                        isLoading: authState.isLoading,
                        onPressed: _login,
                        backgroundColor: AppColors.primaryContainer,
                      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              isEnglish ? 'Or' : 'অথবা',
                              style: AppTextStyles.labelMd.copyWith(color: AppColors.outline),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 24),

                      // Google sign in
                      OutlinedButton.icon(
                        onPressed: authState.isLoading ? null : _googleSignIn,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          side: BorderSide(color: AppColors.outlineVariant),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          foregroundColor: AppColors.onBackground,
                        ),
                        icon: _GoogleIcon(),
                        label: Text(
                          isEnglish ? 'Sign in with Google' : 'Google দিয়ে প্রবেশ করুন',
                          style: AppTextStyles.button,
                        ),
                      ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2),

                      const SizedBox(height: 28),

                      // Register link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: isEnglish ? "Don't have an account? " : "অ্যাকাউন্ট নেই? ",
                            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => context.go(AppRoutes.registerTraveler),
                                  child: Text(
                                    isEnglish ? "Sign Up" : "রেজিস্ট্রেশন করুন",
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20, height: 20, child: CustomPaint(painter: _GooglePainter()));
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.57, 3.14, true, paint);
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.52, 1.57, true, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 1.05, 1.57, true, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 2.62, 0.52, true, paint);
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
