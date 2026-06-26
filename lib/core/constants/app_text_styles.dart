import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLg => GoogleFonts.beVietnamPro(
        fontSize: 48,
        height: 56 / 48,
        letterSpacing: -0.02 * 48,
        fontWeight: FontWeight.w700,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineLg => GoogleFonts.beVietnamPro(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.beVietnamPro(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineMd => GoogleFonts.beVietnamPro(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineSm => GoogleFonts.beVietnamPro(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get titleLg => GoogleFonts.beVietnamPro(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get titleMd => GoogleFonts.beVietnamPro(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get bodyLg => GoogleFonts.beVietnamPro(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackground,
      );

  static TextStyle get bodyMd => GoogleFonts.beVietnamPro(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onBackground,
      );

  static TextStyle get bodySm => GoogleFonts.beVietnamPro(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelLg => GoogleFonts.beVietnamPro(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackground,
      );

  static TextStyle get labelMd => GoogleFonts.beVietnamPro(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.01 * 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onBackground,
      );

  static TextStyle get labelSm => GoogleFonts.beVietnamPro(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get button => GoogleFonts.beVietnamPro(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get caption => GoogleFonts.beVietnamPro(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      );
}
