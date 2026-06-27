import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // User is already logged in — determine their role
      final role = await AuthService().getUserRole();
      if (!mounted) return;
      if (role == 'business') {
        context.go(AppRoutes.businessDashboard);
      } else {
        context.go(AppRoutes.home);
      }
    } else {
      // Not logged in — check if they've selected language
      final prefs = await SharedPreferences.getInstance();
      final hasSelectedLang = prefs.getString('app_language') != null;
      if (!mounted) return;
      if (hasSelectedLang) {
        context.go(AppRoutes.onboarding);
      } else {
        context.go(AppRoutes.languageSelect);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF003D1E),
              Color(0xFF005127),
              Color(0xFF1B6B3A),
              Color(0xFF267A44),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // App name
                  Text(
                    'Travel BD',
                    style: AppTextStyles.displayLg.copyWith(
                      color: Colors.white,
                      fontSize: 42,
                      letterSpacing: -1,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 300.ms)
                      .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 300.ms),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    'বাংলাদেশ আবিষ্কার করুন',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 500.ms),

                  const SizedBox(height: 8),

                  // Gold accent line
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                      .animate()
                      .scaleX(duration: 600.ms, delay: 700.ms, curve: Curves.easeOut)
                      .fadeIn(delay: 700.ms),
                ],
              ),
            ),

            // Bottom loading indicator
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: AppTextStyles.labelMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 900.ms),
            ),
          ],
        ),
      ),
    );
  }
}
