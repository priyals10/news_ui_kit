import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// IMAGE
        Expanded(
          flex: 7,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),

        /// TEXT SECTION
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingH,
              vertical: AppSizes.spacingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.onboardingTitle,
                ),
                const SizedBox(height: AppSizes.spacingS),
                Text(
                  description,
                  style: AppTextStyles.onboardingDesc,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
