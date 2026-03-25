import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';

/// A reusable primary [ElevatedButton] that inherits the app's button theme.
///
/// Use [AppButton] everywhere instead of raw [ElevatedButton.styleFrom()] to
/// keep styling centralised and consistent. If the design changes, update here.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.fullWidth = true,
    this.height,
    this.horizontalPadding = 24,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: isEnabled
            ? ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: AppColors.greyLight,
                foregroundColor: AppColors.greyDark,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
              ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}

/// Outlined variant of [AppButton].
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fullWidth = true,
    this.height,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
