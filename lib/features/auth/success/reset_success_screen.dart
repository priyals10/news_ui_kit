import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: WebConstrainedLayout(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingHuge),

              Image.asset(AppAssets.logo, width: AppSizes.successLogoWidth),

              const SizedBox(height: 2),

              Text(
                AppStrings.congratulations,
                style: AppTextStyles.headingMedium(context).copyWith(fontSize: 34),
              ),

              const SizedBox(height: AppSizes.spacingS),

              Text(
                AppStrings.accountReady,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(context),
              ),

              const SizedBox(height: AppSizes.spacingHuge),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.login,
                      (route) => false,
                    );
                  },
                  child: const Text("Go to Login"),
                ),
              ),

              const SizedBox(height: AppSizes.spacingXXL),
            ],
          ),
        ),
      ),
    );
  }
}
