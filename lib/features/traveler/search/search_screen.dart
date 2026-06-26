import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/locale_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getCategoryLabel(String key, bool isBn) {
    if (!isBn) {
      switch (key) {
        case 'হোটেল': return 'Hotels';
        case 'রেস্টুরেন্ট': return 'Restaurants';
        case 'গাইড': return 'Guides';
      }
    }
    return key;
  }

  String _getTypeLabel(String type, bool isBn) {
    if (!isBn) {
      switch (type) {
        case 'গন্তব্য': return 'Destination';
        case 'হোটেল': return 'Hotel';
        case 'প্যাকেজ': return 'Package';
      }
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    final isBn = ref.watch(localeProvider) == AppLanguage.bn;
    final tr = ref.watch(localeProvider.notifier).translate;

    final recentSearches = isBn
        ? ["Cox's Bazar", 'সাজেক ভ্যালি', 'Long Beach Hotel', 'করিম উদ্দিন']
        : ["Cox's Bazar", 'Sajek Valley', 'Long Beach Hotel', 'Karim Uddin'];

    final trending = isBn
        ? ['সুন্দরবন', 'সেন্ট মার্টিন', 'বান্দরবান', 'রাতারগুল']
        : ['Sundarbans', 'Saint Martin', 'Bandarban', 'Ratargul'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Hero(
                      tag: 'search_bar_hero',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.outlineVariant),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                          ),
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: isBn ? 'হোটেল, রেস্টুরেন্ট, গন্তব্য...' : 'Hotel, Restaurant, Destination...',
                              prefixIcon: Icon(Icons.search_rounded, color: AppColors.outline),
                              suffixIcon: _query.isNotEmpty
                                  ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () { _controller.clear(); setState(() => _query = ''); })
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _query.isEmpty ? _buildSuggestions(recentSearches, trending, isBn, tr) : _buildResults(isBn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(List<String> recent, List<String> trending, bool isBn, String Function(String) tr) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Recent
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(isBn ? 'সাম্প্রতিক অনুসন্ধান' : 'Recent Searches', style: AppTextStyles.headlineSm),
          TextButton(onPressed: () {}, child: Text(isBn ? 'মুছুন' : 'Clear', style: AppTextStyles.labelLg.copyWith(color: AppColors.error))),
        ]),
        const SizedBox(height: 8),
        ...recent.map((s) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.history_rounded, color: AppColors.onSurfaceVariant),
          title: Text(s, style: AppTextStyles.bodyMd),
          trailing: Icon(Icons.north_west_rounded, size: 16, color: AppColors.onSurfaceVariant),
          onTap: () => setState(() { _query = s; _controller.text = s; }),
        )),

        const SizedBox(height: 16),

        // Trending
        Text(isBn ? 'ট্রেন্ডিং' : 'Trending', style: AppTextStyles.headlineSm),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: trending.map((t) => GestureDetector(
            onTap: () => setState(() { _query = t; _controller.text = t; }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.trending_up_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(t, style: AppTextStyles.labelLg),
              ]),
            ),
          )).toList(),
        ),

        const SizedBox(height: 24),

        // Categories
        Text(isBn ? 'ক্যাটাগরি অনুযায়ী' : 'Browse Categories', style: AppTextStyles.headlineSm),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3, childAspectRatio: 1.1, crossAxisSpacing: 10, mainAxisSpacing: 10,
          children: [
            {'icon': Icons.hotel_rounded, 'label': 'হোটেল', 'route': '/hotels'},
            {'icon': Icons.restaurant_rounded, 'label': 'রেস্টুরেন্ট', 'route': '/restaurants'},
            {'icon': Icons.person_pin_rounded, 'label': 'গাইড', 'route': '/guides'},
          ].map((c) => GestureDetector(
            onTap: () => context.push(c['route'] as String),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(c['icon'] as IconData, color: AppColors.primary, size: 24),
                  const SizedBox(height: 8),
                  Text(_getCategoryLabel(c['label'] as String, isBn), style: AppTextStyles.labelLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildResults(bool isBn) {
    final results = [
      {'type': 'গন্তব্য', 'name': "Cox's Bazar Beach", 'sub': isBn ? 'চট্টগ্রাম' : 'Chattogram', 'icon': Icons.place_rounded},
      {'type': 'হোটেল', 'name': 'Long Beach Hotel', 'sub': "Cox's Bazar", 'icon': Icons.hotel_rounded},
      {'type': 'প্যাকেজ', 'name': "Cox's Bazar Special", 'sub': isBn ? '৩ দিন · ৳৮,৫০০' : '3 Days · ৳8,500', 'icon': Icons.luggage_rounded},
    ].where((r) => (r['name'] as String).toLowerCase().contains(_query.toLowerCase())).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 60, color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            Text(
              isBn ? '"$_query" এর জন্য কিছু পাওয়া যায়নি' : 'No results found for "$_query"',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final r = results[i];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(r['icon'] as IconData, color: AppColors.primaryContainer, size: 20),
          ),
          title: Text(r['name'] as String, style: AppTextStyles.bodyMd),
          subtitle: Text('${_getTypeLabel(r['type'] as String, isBn)} · ${r['sub']}', style: AppTextStyles.labelSm),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () {},
        ).animate(delay: (i * 50).ms).fadeIn();
      },
    );
  }
}
