import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_widgets.dart';

class HotelListingScreen extends StatefulWidget {
  const HotelListingScreen({super.key});

  @override
  State<HotelListingScreen> createState() => _HotelListingScreenState();
}

class _HotelListingScreenState extends State<HotelListingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Profile data controllers
  final _hotelNameController = TextEditingController(text: 'Long Beach Hotel');
  final _hotelDescriptionController = TextEditingController(
    text: 'কক্সবাজার সমুদ্র সৈকতের খুব কাছেই একটি লাক্সারি ফাইভ স্টার মানের হোটেল। এখানে পাবেন আধুনিক সুযোগ-সুবিধা এবং দুর্দান্ত ভিউ।',
  );
  final _hotelAddressController = TextEditingController(text: 'কলাতলী রোড, কক্সবাজার');

  // Amenities checklist
  final Map<String, bool> _amenities = {
    'ফ্রি ওয়াই-ফাই': true,
    'সুইমিং পুল': true,
    'রুম সার্ভিস': true,
    'রেস্টুরেন্ট': true,
    'জিম': false,
    'স্পা': false,
    'ফ্রি পার্কিং': true,
    'এয়ার কন্ডিশনার': true,
  };

  // Sample room types
  final List<Map<String, dynamic>> _roomTypes = [
    {
      'name': 'ডিলাক্স ডাবল রুম',
      'price': 4500,
      'capacity': 2,
      'availableCount': 15,
      'description': 'সমুদ্রমুখী জানালা সহ এসি ডাবল রুম।',
      'seasonalPrice': 5500,
      'isSeasonalEnabled': true,
    },
    {
      'name': 'এক্সিকিউটিভ সুইট',
      'price': 8500,
      'capacity': 3,
      'availableCount': 5,
      'description': 'লাক্সারি সোফা, প্রাইভেট বার এবং কিংসাইজ বেড।',
      'seasonalPrice': 10500,
      'isSeasonalEnabled': false,
    },
  ];

  // Blocked dates list (simplified for mockup)
  final Set<DateTime> _blockedDates = {
    DateTime(2026, 7, 10),
    DateTime(2026, 7, 11),
    DateTime(2026, 7, 15),
  };

  // Calendar current month
  DateTime _currentMonth = DateTime(2026, 7);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hotelNameController.dispose();
    _hotelDescriptionController.dispose();
    _hotelAddressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('হোটেল প্রোফাইল সফলভাবে আপডেট করা হয়েছে'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  void _addRoomType() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddRoomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'হোটেল লিস্টিং',
        showBack: false,
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline_rounded,
                color: AppColors.primary),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surfaceContainerLowest,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              labelStyle: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'প্রোফাইল'),
                Tab(text: 'রুম টাইপ'),
                Tab(text: 'ক্যালেন্ডার'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildRoomTypesTab(),
                _buildCalendarTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PROFILE TAB ---
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('হোটেল তথ্য', style: AppTextStyles.titleMd),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _hotelNameController,
                    style: AppTextStyles.bodyLg,
                    decoration: const InputDecoration(
                      labelText: 'হোটেলের নাম',
                      prefixIcon: Icon(Icons.hotel_rounded),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'হোটেলের নাম লিখুন' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hotelAddressController,
                    style: AppTextStyles.bodyLg,
                    decoration: const InputDecoration(
                      labelText: 'ঠিকানা',
                      prefixIcon: Icon(Icons.location_on_rounded),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'ঠিকানা লিখুন' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hotelDescriptionController,
                    style: AppTextStyles.bodyLg,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'বিবরণ (Description)',
                      prefixIcon: Icon(Icons.description_rounded),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'হোটেলের বিবরণ লিখুন' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Photos Management
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('হোটেলের ছবি সমূহ', style: AppTextStyles.titleMd),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                  label: const Text('যোগ করুন'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPhotoCard(
                      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&auto=format&fit=crop&q=60'),
                  _buildPhotoCard(
                      'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=500&auto=format&fit=crop&q=60'),
                  _buildPhotoCard(
                      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500&auto=format&fit=crop&q=60'),
                  // Add photo button representation
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Icon(Icons.add_a_photo_rounded,
                        color: AppColors.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amenities Section
            Text('সুযোগ-সুবিধা (Amenities)', style: AppTextStyles.titleMd),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
                ],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _amenities.keys.map((key) {
                  final isSelected = _amenities[key] ?? false;
                  return FilterChip(
                    label: Text(key),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTextStyles.labelLg.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _amenities[key] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            AppButton(
              label: 'প্রোফাইল সংরক্ষণ করুন',
              icon: Icons.save_rounded,
              onPressed: _saveProfile,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String url) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ROOM TYPES TAB ---
  Widget _buildRoomTypesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _roomTypes.length + 1,
      itemBuilder: (context, index) {
        if (index == _roomTypes.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: AppButton(
              label: 'নতুন রুম টাইপ যোগ করুন',
              icon: Icons.add_circle_outline_rounded,
              isOutlined: true,
              onPressed: _addRoomType,
            ),
          );
        }

        final room = _roomTypes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room header image (placeholder mock)
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500&auto=format&fit=crop&q=60'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    gradient: AppColors.heroGradient,
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    room['name'],
                    style: AppTextStyles.titleLg.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room['description'],
                      style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildInfoChip(
                            Icons.people_alt_rounded, 'সর্বোচ্চ ${room['capacity']} জন'),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            Icons.airline_seat_individual_suite_rounded,
                            'রুম সংখ্যা: ${room['availableCount']}'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'মূল রেট:',
                              style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant),
                            ),
                            Text(
                              '৳${room['price']} /রাত',
                              style: AppTextStyles.titleLg.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (room['isSeasonalEnabled'])
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusBadge(
                                  label: 'উৎসবের দাম সক্রিয়',
                                  color: AppColors.warningAmber),
                              Text(
                                '৳${room['seasonalPrice']} /রাত',
                                style: AppTextStyles.titleMd.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        else
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                room['isSeasonalEnabled'] = true;
                              });
                            },
                            icon: const Icon(Icons.bolt_rounded, size: 16),
                            label: const Text('ঈদ/উৎসবের দাম দিন'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.secondary,
                              side: BorderSide(color: AppColors.secondaryContainer),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.1);
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.labelSm),
        ],
      ),
    );
  }

  // --- CALENDAR TAB ---
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('তারিখ ব্লক / প্রাপ্যতা', style: AppTextStyles.titleMd),
          const SizedBox(height: 6),
          Text(
            'ক্যালেন্ডার থেকে যেকোনো তারিখে ট্যাপ করে বুকিং ব্লক বা আনব্লক করুন (রক্ষণাবেক্ষণ বা নিজস্ব হোল্ডের জন্য)।',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Calendar Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: AppTextStyles.titleLg.copyWith(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),

          // Calendar Body
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
              ],
            ),
            child: Column(
              children: [
                // Days of week
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['শনি', 'রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র']
                      .map<Widget>((d) => Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(d,
                                style: AppTextStyles.labelMd.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurfaceVariant)),
                          ))
                      .toList(),
                ),
                const Divider(height: 20),
                // Days Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 35, // standard 5 weeks representation
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, idx) {
                    // Simple mockup calendar building for July 2026
                    // July 1 2026 is Wednesday (index 4 in BD week starting Saturday)
                    final dayNumber = idx - 3;
                    if (dayNumber <= 0 || dayNumber > 31) {
                      return const SizedBox();
                    }

                    final date = DateTime(
                        _currentMonth.year, _currentMonth.month, dayNumber);
                    final isBlocked = _blockedDates.contains(date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isBlocked) {
                            _blockedDates.remove(date);
                          } else {
                            _blockedDates.add(date);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isBlocked
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isBlocked
                                ? AppColors.error
                                : AppColors.outlineVariant.withValues(alpha: 0.5),
                            width: isBlocked ? 1.5 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayNumber',
                              style: AppTextStyles.bodyLg.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isBlocked ? AppColors.error : AppColors.primary,
                              ),
                            ),
                            if (isBlocked)
                              Icon(Icons.block_rounded,
                                  size: 10, color: AppColors.error),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                  AppColors.primary.withValues(alpha: 0.05),
                  AppColors.outlineVariant,
                  'প্রাপ্য (Available)'),
              const SizedBox(width: 24),
              _buildLegendItem(
                  AppColors.error.withValues(alpha: 0.15),
                  AppColors.error,
                  'ব্লক করা (Blocked)'),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color fill, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.labelMd),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return months[month - 1];
  }

  // --- ADD ROOM SHEET ---
  Widget _buildAddRoomSheet() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final capCtrl = TextEditingController();
    final countCtrl = TextEditingController();
    final descCtrl = TextEditingController();

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
                Text('নতুন রুম টাইপ যোগ করুন', style: AppTextStyles.headlineSm),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 8),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: 'রুমের নাম (যেমন: ডিলাক্স ফ্যামিলি সুইট)',
                prefixIcon: Icon(Icons.king_bed_rounded),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'মূল্য (৳/রাত)',
                      prefixIcon: Icon(Icons.payments_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: capCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'ধারণক্ষমতা (জন)',
                      prefixIcon: Icon(Icons.people_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: countCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'মোট রুমের সংখ্যা',
                prefixIcon: Icon(Icons.numbers_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'রুমের সংক্ষিপ্ত বিবরণ',
                prefixIcon: Icon(Icons.subject_rounded),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'রুম টাইপ সংরক্ষণ করুন',
              icon: Icons.add_circle_rounded,
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  setState(() {
                    _roomTypes.add({
                      'name': nameCtrl.text,
                      'price': int.parse(priceCtrl.text),
                      'capacity': int.tryParse(capCtrl.text) ?? 2,
                      'availableCount': int.tryParse(countCtrl.text) ?? 10,
                      'description': descCtrl.text.isNotEmpty
                          ? descCtrl.text
                          : 'কোন বিবরণ দেওয়া হয়নি।',
                      'seasonalPrice': (double.parse(priceCtrl.text) * 1.25).round(),
                      'isSeasonalEnabled': false,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('নতুন রুম টাইপ যোগ করা হয়েছে'),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
