import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../core/constants/app_constants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('প্রিয় গন্তব্য', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78,
        ),
        itemCount: 4,
        itemBuilder: (_, i) {
          const places = AppConstants.popularDestinations;
          return DestinationCard(
            name: places[i]['name']!,
            location: places[i]['division']!,
            imageUrl: [AppConstants.coxBazarImage, AppConstants.sajekImage, AppConstants.sundarbanImage, AppConstants.bandarbanImage][i],
            rating: 4.5 + (i * 0.1),
            isFavorite: true,
          );
        },
      ),
    );
  }
}
