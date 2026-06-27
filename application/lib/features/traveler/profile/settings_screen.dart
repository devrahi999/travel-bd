import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/utils/app_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _locationServices = true;
  String _selectedCurrency = 'BDT (৳)';

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(localeProvider) == AppLanguage.en;
    final currentLang = isEnglish ? 'English' : 'বাংলা';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: isEnglish ? 'Settings' : 'সেটিংস'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(isEnglish ? 'Notifications' : 'নোটিফিকেশন'),
          _SwitchTile(label: isEnglish ? 'Push Notifications' : 'পুশ নোটিফিকেশন', icon: Icons.notifications_rounded, value: _pushNotifications, onChanged: (v) => setState(() => _pushNotifications = v)),

          const SizedBox(height: 16),
          _SectionTitle(isEnglish ? 'Privacy' : 'গোপনীয়তা'),
          _SwitchTile(label: isEnglish ? 'Location Services' : 'লোকেশন সার্ভিস', icon: Icons.location_on_rounded, value: _locationServices, onChanged: (v) => setState(() => _locationServices = v)),

          const SizedBox(height: 16),
          _SectionTitle(isEnglish ? 'Preferences' : 'পছন্দ'),
          _SwitchTile(
            label: isEnglish ? 'Dark Theme' : 'ডার্ক থিম',
            icon: Icons.dark_mode_rounded,
            value: ref.watch(themeProvider) == ThemeMode.dark,
            onChanged: (v) {
              ref.read(themeProvider.notifier).setThemeMode(
                v ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          _SelectTile(label: isEnglish ? 'Language' : 'ভাষা', icon: Icons.language_rounded, value: currentLang,
            options: const ['বাংলা', 'English'],
            onChanged: (v) {
              if (v != null) {
                ref.read(localeProvider.notifier).setLanguage(
                  v == 'English' ? AppLanguage.en : AppLanguage.bn,
                );
              }
            },
          ),
          _SelectTile(label: isEnglish ? 'Currency' : 'মুদ্রা', icon: Icons.currency_exchange_rounded, value: _selectedCurrency,
            options: const ['BDT (৳)', 'USD (\$)', 'EUR (€)'],
            onChanged: (v) => setState(() => _selectedCurrency = v ?? 'BDT (৳)'),
          ),

          const SizedBox(height: 16),
          _SectionTitle(isEnglish ? 'Account' : 'অ্যাকাউন্ট'),
          _ActionTile(label: isEnglish ? 'Change Password' : 'পাসওয়ার্ড পরিবর্তন', icon: Icons.lock_outline_rounded, onTap: () => _showChangePasswordModal(context, isEnglish)),
          _ActionTile(label: isEnglish ? 'Delete Account' : 'অ্যাকাউন্ট মুছে ফেলুন', icon: Icons.delete_outline_rounded, onTap: () {}, color: AppColors.error),

          const SizedBox(height: 16),
          _SectionTitle(isEnglish ? 'About App' : 'অ্যাপ সম্পর্কে'),
          _InfoTile(label: isEnglish ? 'App Version' : 'অ্যাপ ভার্সন', value: '1.0.0'),
          _ActionTile(label: 'Terms & Conditions', icon: Icons.description_outlined, onTap: () {}),
          _ActionTile(label: 'Privacy Policy', icon: Icons.privacy_tip_outlined, onTap: () {}),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context, bool isEnglish) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final supabase = Supabase.instance.client;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEnglish ? 'Change Password' : 'পাসওয়ার্ড পরিবর্তন', style: AppTextStyles.titleLg),
            const SizedBox(height: 16),
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isEnglish ? 'Current Password' : 'বর্তমান পাসওয়ার্ড',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isEnglish ? 'New Password' : 'নতুন পাসওয়ার্ড',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (newPasswordController.text.length < 6) return;
                  try {
                    await supabase.auth.updateUser(
                      UserAttributes(password: newPasswordController.text),
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      AppToast.show(context, isEnglish ? 'Password updated successfully!' : 'পাসওয়ার্ড সফলভাবে আপডেট হয়েছে!');
                    }
                  } catch (e) {
                    if (ctx.mounted) {
                      AppToast.show(context, isEnglish ? 'Failed to update password' : 'পাসওয়ার্ড আপডেট ব্যর্থ হয়েছে', isError: true);
                    }
                  }
                },
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(isEnglish ? 'Update Password' : 'পাসওয়ার্ড আপডেট করুন'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.label, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.onBackground),
        ),
        title: Text(label, style: AppTextStyles.bodyMd),
        trailing: AdaptiveSwitch(value: value, onChanged: onChanged),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  const _SelectTile({required this.label, required this.icon, required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: AppColors.onBackground),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodyMd)),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
            borderRadius: BorderRadius.circular(12),
            onChanged: onChanged,
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _ActionTile({required this.label, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: (color ?? AppColors.onSurfaceVariant).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: color ?? AppColors.onBackground),
        ),
        title: Text(label, style: AppTextStyles.bodyMd.copyWith(color: color)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color ?? AppColors.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.info_outline_rounded, size: 20),
        title: Text(label, style: AppTextStyles.bodyMd),
        trailing: Text(value, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
      ),
    );
  }
}
