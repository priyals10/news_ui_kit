import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class WelcomeSuccessScreen extends StatelessWidget {
  const WelcomeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: WebConstrainedLayout(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.spacingHuge),

              Image.asset(AppAssets.logo, width: AppSizes.successLogoWidth),

              const SizedBox(height: 32),

              Text(
                "Welcome to Kabar!",
                style: AppTextStyles.headingMedium(context).copyWith(fontSize: 34),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spacingS),

              const Text(
                "Your account is ready and your feed is personalized just for you. Start exploring the latest news today!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.home,
                      (route) => false,
                    );
                  },
                  child: const Text("Go to Home"),
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
