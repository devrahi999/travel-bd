import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable Liquid Glass UI utilities for Travel BD.
/// 
/// These widgets use BackdropFilter for cross-platform glass/blur effects.
/// Apply ONLY to premium interactive elements (nav bars, search bars,
/// bottom sheets, AI input, FABs, toggles, sliders).
/// Do NOT use on scrolling content, cards, lists, or forms.
class GlassTheme {
  GlassTheme._();
  
  // ─── Glass Container (base building block) ──────────────────────

  /// A reusable glass container with blur and tint.
  /// Used as the foundation for all glass elements.
  static Widget glassContainer({
    required Widget child,
    double blurSigma = 12.0,
    double opacity = 0.15,
    Color? tintColor,
    double borderRadius = 0.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? shadows,
    double? width,
    double? height,
    Border? border,
    BoxConstraints? constraints,
    VoidCallback? onTap,
  }) {
    final effectiveTint = tintColor ?? AppColors.surface;
    final container = Container(
      width: width,
      height: height,
      margin: margin,
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveTint.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              boxShadow: shadows,
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }

  // ─── Glass Search Bar ────────────────────────────────────────────

  /// Builds a glass-styled search bar with frosted glass appearance.
  static Widget glassSearchBar({
    required TextEditingController controller,
    required String hintText,
    required ValueChanged<String> onChanged,
    VoidCallback? onTap,
    String? query,
    VoidCallback? onClear,
    bool autofocus = false,
    double height = 50,
    double borderRadius = 25,
  }) {
    return GlassTheme.glassContainer(
      blurSigma: 10,
      opacity: 0.12,
      borderRadius: borderRadius,
      width: double.infinity,
      height: height,
      border: Border.all(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
        width: 0.5,
      ),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: AppColors.primary.withValues(alpha: 0.7), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
            ),
          ),
          if (query != null && query.isNotEmpty && onClear != null)
            IconButton(
              icon: Icon(Icons.clear_rounded, size: 18, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)),
              onPressed: onClear,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  // ─── Glass Bottom Sheet ──────────────────────────────────────────

  /// Shows a bottom sheet with a glass background and blurred backdrop.
  static Future<T?> showGlassBottomSheet<T>({
    required BuildContext context,
    required Widget builder(BuildContext context),
    double initialChildSize = 0.5,
    double maxChildSize = 0.9,
    double minChildSize = 0.25,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (ctx) => GlassTheme.glassContainer(
        blurSigma: 20,
        opacity: 0.08,
        tintColor: Colors.white,
        borderRadius: 24,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.5,
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          expand: false,
          builder: (ctx, scrollController) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: builder(ctx),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Glass AI Chat Input ─────────────────────────────────────────

  /// Floating glass chat input bar for the AI Planner screen.
  static Widget glassChatInput({
    required TextEditingController controller,
    required VoidCallback onSend,
    required String hintText,
    required Color sendButtonColor,
    String? text,
  }) {
    return GlassTheme.glassContainer(
      blurSigma: 16,
      opacity: 0.1,
      borderRadius: 28,
      border: Border.all(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.25),
        width: 0.5,
      ),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Glass send button
          GlassTheme.glassContainer(
            blurSigma: 8,
            opacity: 0.2,
            tintColor: sendButtonColor,
            borderRadius: 26,
            width: 44,
            height: 44,
            border: Border.all(
              color: sendButtonColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
            child: IconButton(
              onPressed: (text?.trim().isEmpty ?? true) ? null : onSend,
              icon: Icon(Icons.send_rounded, size: 18, color: Colors.white),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.expand(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Glass FAB ───────────────────────────────────────────────────

  /// Floating action button with glass styling.
  static Widget glassFloatingActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    double size = 56,
    Color? tintColor,
  }) {
    final color = tintColor ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: GlassTheme.glassContainer(
        blurSigma: 12,
        opacity: 0.15,
        tintColor: color,
        borderRadius: size / 2,
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.5,
        ),
        shadows: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: onPressed,
            splashColor: color.withValues(alpha: 0.1),
            highlightColor: color.withValues(alpha: 0.05),
            child: Center(
              child: Icon(icon, color: Colors.white, size: size * 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
