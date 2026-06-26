import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/app_router.dart';
import 'core/providers/theme_provider.dart';

import 'dart:ui';
import 'core/constants/app_colors.dart';

const String supabaseUrl = 'https://ilulisnpoppspulxctcv.supabase.co';
const String supabaseAnonKey = 'sb_publishable_iQ0mAvyQ_kxY__e6mExVyA_whABmen-';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  runApp(const ProviderScope(child: TravelBDApp()));
}

class TravelBDApp extends ConsumerWidget {
  const TravelBDApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    final isDark = themeMode == ThemeMode.dark || (themeMode == ThemeMode.system && platformBrightness == Brightness.dark);
    
    AppColors.updateTheme(isDark);

    return MaterialApp.router(
      title: 'Travel BD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
