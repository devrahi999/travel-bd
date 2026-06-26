import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/providers/locale_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(int pagesCount) {
    if (_currentPage < pagesCount - 1) {
      _controller.nextPage(
          duration: 400.ms, curve: Curves.easeInOutCubic);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    
    final pages = [
      _OnboardingData(
        imageUrl: 'assets/images/coxs_bazar.png',
        title: tr('onboard_title_1'),
        subtitle: tr('onboard_subtitle_1'),
        accentColor: const Color(0xFFFEAE2C),
      ),
      _OnboardingData(
        imageUrl: 'assets/images/sajeek.jpg',
        title: tr('onboard_title_2'),
        subtitle: tr('onboard_subtitle_2'),
        accentColor: const Color(0xFF80DEEA),
      ),
      _OnboardingData(
        imageUrl: 'assets/images/bandorban.jpg',
        title: tr('onboard_title_3'),
        subtitle: tr('onboard_subtitle_3'),
        accentColor: const Color(0xFFCE93D8),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: pages.length,
            itemBuilder: (context, i) => _OnboardingPage(data: pages[i]),
          ),

          // Skip button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: Text(
                    tr('onboard_skip'),
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 32,
                top: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.secondaryContainer,
                      dotColor: Colors.white.withValues(alpha: 0.4),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Next / Get Started button
                  GestureDetector(
                    onTap: () => _next(pages.length),
                    child: AnimatedContainer(
                      duration: 300.ms,
                      width: _currentPage == pages.length - 1
                          ? double.infinity
                          : 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(
                          _currentPage == pages.length - 1 ? 16 : 30,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _currentPage == pages.length - 1
                            ? Text(
                                '${tr('onboard_start')}  →',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.onSecondaryContainer,
                                  fontSize: 16,
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.onSecondaryContainer,
                                size: 26,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          data.imageUrl,
          fit: BoxFit.cover,
        ),
        // Dark Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),

        // Content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    data.title,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 16),

                  // Accent divider
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: data.accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ).animate().scaleX(delay: 400.ms, duration: 400.ms),

                  const SizedBox(height: 20),

                  // Subtitle
                  Text(
                    data.subtitle,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _OnboardingData {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Color accentColor;

  const _OnboardingData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
}
