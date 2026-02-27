import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: isEnabled
            ? null // uses theme default (blue)
            : ElevatedButton.styleFrom(
                backgroundColor: AppColors.greyLight,
                foregroundColor: AppColors.greyDark,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.buttonPaddingV,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
              ),
        child: Text(text),
      ),
    );
  }
}
