import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? borderColor;
  final double? borderRadius;
  final double? height;

  const AppSearchField({
    super.key,
    required this.controller,
    this.hintText = AppStrings.search,
    this.borderColor,
    this.borderRadius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusL),
        border: Border.all(color: borderColor ?? (isDark ? Colors.transparent : colorScheme.outline)),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.inputPaddingH + 2,
            vertical: AppSizes.inputPaddingV,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppAssets.searchIcon, 
              width: 20,
              colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
