import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/app_router.dart';
import '../../../core/widgets/app_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  // Business fields
  String _ownerName = 'কাজী মারুফ';
  String _bizName = 'Long Beach Hotel';
  String _email = 'maruf@longbeachhotel.com.bd';
  String _phone = '01712345678';
  String _tin = '123456789012';
  String _location = 'Cox\'s Bazar, Bangladesh';

  // Bank Info
  String _bankName = 'ডাচ-বাংলা ব্যাংক লিমিটেড';
  String _accNum = '102.120.45678';
  String _bkashNum = '01712345678';

  final bool _isEditingBank = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusinessProfile();
  }

  Future<void> _fetchBusinessProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final profile = await Supabase.instance.client.from('business_profiles').select().eq('id', user.id).maybeSingle();
        final userProfile = await Supabase.instance.client.from('profiles').select().eq('id', user.id).maybeSingle();
        
        if (mounted) {
          setState(() {
            _ownerName = userProfile?['full_name'] ?? 'No Name';
            _email = user.email ?? '';
            _phone = userProfile?['phone'] ?? '';
            
            if (profile != null) {
              _bizName = profile['business_name'] ?? 'Unknown Business';
              _tin = profile['tin'] ?? 'N/A';
              _bankName = profile['bank_name'] ?? 'N/A';
              _accNum = profile['bank_account_number'] ?? 'N/A';
              _bkashNum = profile['mobile_banking_number'] ?? 'N/A';
              _location = profile['location'] ?? 'Cox\'s Bazar, Bangladesh';
            }
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateBusinessProfile(Map<String, dynamic> data) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client.from('business_profiles').upsert({'id': user.id, ...data});
      _fetchBusinessProfile();
    }
  }

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileSheet(),
    );
  }

  void _showBankDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBankDetailsSheet(),
    );
  }

  void _showDocumentsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDocumentsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'বিজনেস প্রোফাইল',
        showBack: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Business Hero Info Card
            _buildProfileHeroCard(),
            const SizedBox(height: 24),

            // Profile Menus
            Text('অপশনসমূহ',
                style: AppTextStyles.titleMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 10),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.store_rounded,
                title: 'বিজনেস তথ্য পরিবর্তন',
                subtitle: 'নাম, ঠিকানা, ফোন এবং ইমেইল',
                onTap: _showEditProfileSheet,
              ),
              _buildMenuItem(
                icon: Icons.account_balance_rounded,
                title: 'পেমেন্ট ও পে-আউট অ্যাকাউন্ট',
                subtitle: 'ব্যাংক হিসাব ও বিকাশ/নগদ নম্বর',
                onTap: _showBankDetailsSheet,
              ),
              _buildMenuItem(
                icon: Icons.verified_user_rounded,
                title: 'ডকুমেন্ট ও ভেরিফিকেশন',
                subtitle: 'ট্রেড লাইসেন্স ও জাতীয় পরিচয়পত্র',
                onTap: _showDocumentsSheet,
              ),
            ]),
            const SizedBox(height: 20),

            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.swap_horizontal_circle_rounded,
                title: 'ট্রাভেলার মোডে পরিবর্তন',
                subtitle: 'সাধারণ ব্যবহারকারী ইন্টারফেসে যান',
                color: AppColors.secondary,
                onTap: () {
                  context.go(AppRoutes.home);
                },
              ),
              _buildMenuItem(
                icon: Icons.headset_mic_rounded,
                title: 'সহায়তা ও সাপোর্ট কেন্দ্র',
                subtitle: '২৪/৭ মার্চেন্ট হেল্পলাইন',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সাপোর্ট টিমকে কল করা হচ্ছে: ১৬২২২')),
                  );
                },
              ),
            ]),
            const SizedBox(height: 24),

            // Logout Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
                ],
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.logout_rounded, color: AppColors.error),
                ),
                title: Text('লগ আউট',
                    style: AppTextStyles.titleMd.copyWith(color: AppColors.error)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  context.go(AppRoutes.login);
                },
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=500&auto=format&fit=crop&q=60'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _bizName,
                          style: AppTextStyles.titleLg.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_rounded,
                          color: AppColors.secondaryContainer,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'মালিক: $_ownerName',
                      style: AppTextStyles.bodyMd.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'মার্চেন্ট আইডি: #TBDB-90432',
                      style: AppTextStyles.labelMd.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeroStat('৳৩,২৪,০০০', 'চলতি মাসের আয়'),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildHeroStat('২৮৭', 'মোট বুকিং'),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildHeroStat('৪.৭ ★', 'গড় রেটিং'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildHeroStat(String val, String label) {
    return Column(
      children: [
        Text(val,
            style: AppTextStyles.titleLg
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSm.copyWith(color: Colors.white70)),
      ],
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider(height: 1, indent: 60);
          }
          return children[index ~/ 2];
        }),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final themeColor = color ?? AppColors.primary;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: themeColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: themeColor),
      ),
      title: Text(title, style: AppTextStyles.titleMd),
      subtitle: Text(subtitle, style: AppTextStyles.labelSm),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }

  // --- ACTIONS SHEETS ---
  Widget _buildEditProfileSheet() {
    final bizNameCtrl = TextEditingController(text: _bizName);
    final phoneCtrl = TextEditingController(text: _phone);
    final emailCtrl = TextEditingController(text: _email);
    final locationCtrl = TextEditingController(text: _location);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('বিজনেস তথ্য পরিবর্তন', style: AppTextStyles.headlineSm),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 12),
            TextField(
              controller: bizNameCtrl,
              decoration: const InputDecoration(
                labelText: 'বিজনেসের নাম',
                prefixIcon: Icon(Icons.store_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'ফোন নম্বর',
                prefixIcon: Icon(Icons.phone_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'ইমেইল অ্যাড্রেস',
                prefixIcon: Icon(Icons.mail_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(
                labelText: 'ঠিকানা / লোকেশন',
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'পরিবর্তন সংরক্ষণ করুন',
              icon: Icons.check_circle_rounded,
              onPressed: () async {
                Navigator.pop(context);
                await _updateBusinessProfile({
                  'business_name': bizNameCtrl.text,
                  'location': locationCtrl.text,
                });
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  await Supabase.instance.client.from('profiles').update({
                    'phone': phoneCtrl.text,
                  }).eq('id', user.id);
                }
                _fetchBusinessProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('বিজনেস তথ্য সফলভাবে সংরক্ষণ করা হয়েছে'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetailsSheet() {
    final bankNameCtrl = TextEditingController(text: _bankName);
    final accNumCtrl = TextEditingController(text: _accNum);
    final bkashNumCtrl = TextEditingController(text: _bkashNum);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('পে-আউট অ্যাকাউন্ট', style: AppTextStyles.headlineSm),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 12),
            TextField(
              controller: bankNameCtrl,
              decoration: const InputDecoration(
                labelText: 'ব্যাংকের নাম',
                prefixIcon: Icon(Icons.account_balance_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: accNumCtrl,
              decoration: const InputDecoration(
                labelText: 'হিসাব নম্বর (Account No)',
                prefixIcon: Icon(Icons.credit_card_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bkashNumCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'বিকাশ নম্বর (Payout Wallet)',
                prefixIcon: Icon(Icons.phone_iphone_rounded),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'অ্যাকাউন্ট আপডেট করুন',
              icon: Icons.wallet_rounded,
              onPressed: () async {
                Navigator.pop(context);
                await _updateBusinessProfile({
                  'bank_name': bankNameCtrl.text,
                  'bank_account_number': accNumCtrl.text,
                  'mobile_banking_number': bkashNumCtrl.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('পে-আউট তথ্য সফলভাবে আপডেট করা হয়েছে'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ডকুমেন্ট ও ভেরিফিকেশন', style: AppTextStyles.headlineSm),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20),
          const SizedBox(height: 12),
          _buildDocTile('ট্রেড লাইসেন্স', 'TL-CoxB-90234', true),
          const SizedBox(height: 12),
          _buildDocTile('মালিকের NID', '1995-1204-5829-4', true),
          const SizedBox(height: 12),
          _buildDocTile('ট্যাক্স সার্টিফিকেট (TIN)', 'TIN-$_tin', false),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.successGreen, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'আপনার সকল ডকুমেন্ট আমাদের অ্যাডমিন প্যানেল দ্বারা ভেরিফাইড।',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.successGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDocTile(String name, String details, bool isVerified) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.titleMd),
              Text(details, style: AppTextStyles.labelSm),
            ],
          ),
          if (isVerified)
            StatusBadge(label: 'Verified', color: AppColors.successGreen)
          else
            StatusBadge(label: 'Not Submitted', color: AppColors.outline),
        ],
      ),
    );
  }
}
