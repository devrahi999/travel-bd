import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/auth_provider.dart';

class RegisterBusinessScreen extends ConsumerStatefulWidget {
  const RegisterBusinessScreen({super.key});

  @override
  ConsumerState<RegisterBusinessScreen> createState() => _RegisterBusinessScreenState();
}

class _RegisterBusinessScreenState extends ConsumerState<RegisterBusinessScreen> {
  int _step = 1;
  int _selectedBusinessType = -1;

  // Step 1 controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Step 2 controllers
  final _bizNameController = TextEditingController();
  final _bizAddressController = TextEditingController();
  int _selectedDivision = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _bizNameController.dispose();
    _bizAddressController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else if (_step == 3) {
      _submit();
    }
  }

  void _submit() async {
    final businessTypes = ['hotel', 'restaurant', 'tour_guide', 'car_rental', 'tour_company'];
    final businessType = _selectedBusinessType >= 0 ? businessTypes[_selectedBusinessType] : 'hotel';
    final district = AppConstants.divisions[_selectedDivision];

    final success = await ref.read(authNotifierProvider.notifier).registerBusiness(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: _phoneController.text.trim(),
      businessName: _bizNameController.text.trim(),
      businessType: businessType,
      businessAddress: _bizAddressController.text.trim(),
      district: district,
    );
    if (mounted) {
      if (success) {
        setState(() => _step = 4);
      } else {
        final error = ref.read(authNotifierProvider).error ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      }
    }
  }

  String _getDivisionTranslation(int index, String Function(String) tr) {
    switch (index) {
      case 0: return tr('div_dhaka');
      case 1: return tr('div_chattogram');
      case 2: return tr('div_sylhet');
      case 3: return tr('div_rajshahi');
      case 4: return tr('div_khulna');
      case 5: return tr('div_barishal');
      case 6: return tr('div_rangpur');
      case 7: return tr('div_mymensingh');
      default: return AppConstants.divisions[index];
    }
  }

  String _getBusinessTypeTranslation(int index, String Function(String) tr) {
    switch (index) {
      case 0: return tr('biz_type_hotel');
      case 1: return tr('biz_type_restaurant');
      case 2: return tr('biz_type_guide');
      case 3: return tr('biz_type_car');
      case 4: return tr('biz_type_tour_company');
      default: return AppConstants.businessTypes[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(localeProvider.notifier).translate;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(tr),
            _buildStepIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: 300.ms,
                child: _buildStep(tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String Function(String) tr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          if (_step > 1 && _step < 4)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => setState(() => _step--),
            )
          else
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.go(AppRoutes.login),
            ),
          const Spacer(),
          Text(
            tr('register_biz_title'),
            style: AppTextStyles.headlineSm,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    if (_step == 4) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(3, (i) {
          final step = i + 1;
          final isActive = step == _step;
          final isDone = step < _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: 300.ms,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDone || isActive
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep(String Function(String) tr) {
    switch (_step) {
      case 1:
        return _buildStep1(tr);
      case 2:
        return _buildStep2(tr);
      case 3:
        return _buildStep3(tr);
      case 4:
        return _buildStep4(tr);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1(String Function(String) tr) {
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;
    final stepTitle = isBn ? 'ধাপ ১: ${tr('register_biz_step_1')}' : 'Step 1: ${tr('register_biz_step_1')}';

    return SingleChildScrollView(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stepTitle,
              style: AppTextStyles.labelLg.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(tr('register_biz_personal_title'),
              style: AppTextStyles.headlineMd),
          const SizedBox(height: 24),
          _field(_nameController, tr('register_traveler_name'), Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _field(_emailController, tr('register_traveler_email'), Icons.mail_outline_rounded,
              type: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _field(_phoneController, tr('register_biz_phone'), Icons.phone_outlined,
              type: TextInputType.phone),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: tr('register_traveler_pass'),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: tr('register_biz_next'),
            icon: Icons.arrow_forward_rounded,
            onPressed: _next,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(String Function(String) tr) {
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;
    final stepTitle = isBn ? 'ধাপ ২: ${tr('register_biz_step_2')}' : 'Step 2: ${tr('register_biz_step_2')}';

    return SingleChildScrollView(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stepTitle,
              style: AppTextStyles.labelLg.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(tr('register_biz_info_title'),
              style: AppTextStyles.headlineMd),
          const SizedBox(height: 24),

          // Business type
          Text(tr('register_biz_type'), style: AppTextStyles.labelLg.copyWith(
              color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(AppConstants.businessTypes.length, (i) {
              final isSelected = _selectedBusinessType == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedBusinessType = i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                    ),
                  ),
                  child: Text(
                    _getBusinessTypeTranslation(i, tr),
                    style: AppTextStyles.labelLg.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppColors.onBackground,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          _field(_bizNameController, tr('register_biz_name'), Icons.store_outlined),
          const SizedBox(height: 16),
          _field(_bizAddressController, tr('register_biz_address'), Icons.location_on_outlined),
          const SizedBox(height: 16),

          // Division dropdown
          Text(tr('register_biz_division'), style: AppTextStyles.labelLg.copyWith(
              color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outlineVariant),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surfaceContainerLowest,
            ),
            child: DropdownButton<int>(
              value: _selectedDivision,
              isExpanded: true,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12),
              onChanged: (v) => setState(() => _selectedDivision = v ?? 0),
              items: List.generate(
                AppConstants.divisions.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(_getDivisionTranslation(i, tr),
                      style: AppTextStyles.bodyMd),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: tr('register_biz_next'),
            icon: Icons.arrow_forward_rounded,
            onPressed: _next,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(String Function(String) tr) {
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;
    final stepTitle = isBn ? 'ধাপ ৩: ${tr('register_biz_step_3')}' : 'Step 3: ${tr('register_biz_step_3')}';

    return SingleChildScrollView(
      key: const ValueKey('step3'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stepTitle,
              style: AppTextStyles.labelLg.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(tr('register_biz_docs_title'),
              style: AppTextStyles.headlineMd),
          const SizedBox(height: 8),
          Text(
            tr('register_biz_docs_desc'),
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _uploadCard(tr('register_biz_license'), Icons.description_outlined, required: true, tr: tr),
          const SizedBox(height: 16),
          _uploadCard(tr('register_biz_nid'), Icons.badge_outlined, required: true, tr: tr),
          const SizedBox(height: 16),
          _uploadCard(tr('register_biz_photo'), Icons.photo_library_outlined, required: false, tr: tr),
          const SizedBox(height: 32),
          AppButton(
            label: tr('register_biz_submit'),
            icon: Icons.send_rounded,
            isLoading: ref.watch(authNotifierProvider).isLoading,
            onPressed: _next,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4(String Function(String) tr) {
    return Center(
      key: const ValueKey('step4'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(),
            const SizedBox(height: 28),
            Text(
              tr('register_biz_success_title'),
              style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
            const SizedBox(height: 16),
            Text(
              tr('register_biz_success_body'),
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 40),
            AppButton(
              label: tr('register_traveler_already_have').contains('?')
                  ? tr('login_btn')
                  : tr('register_biz_dashboard_btn'),
              icon: Icons.login_rounded,
              onPressed: () => context.go(AppRoutes.login),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String hint,
    IconData icon, {
    TextInputType? type,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _uploadCard(String title, IconData icon, {required bool required, required String Function(String) tr}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.outlineVariant,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceContainerLowest,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.titleMd),
                      if (required) ...[
                        const SizedBox(width: 6),
                        Text('*',
                            style: AppTextStyles.titleMd
                                .copyWith(color: AppColors.error)),
                      ],
                    ],
                  ),
                  Text(
                    tr('register_biz_upload_hint'),
                    style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.upload_rounded, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
