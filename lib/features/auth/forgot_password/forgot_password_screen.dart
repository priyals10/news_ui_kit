import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WebConstrainedLayout(
        maxWidth: 500,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacingHuge),
            Text(AppStrings.forgotPasswordTitle, style: AppTextStyles.headingLarge(context)),
            const SizedBox(height: AppSizes.spacingM),
            Text(AppStrings.forgotPasswordDesc, style: AppTextStyles.bodyLarge(context)),
            const SizedBox(height: 50),

            AppTextField(
              label: AppStrings.email,
              controller: emailController,
              hintText: 'Enter your email',
            ),

            const SizedBox(height: AppSizes.spacingXL),

            AppPrimaryButton(
              text: AppStrings.submit,
              onPressed: () => Navigator.pushNamed(context, AppRouter.otpVerification, arguments: emailController.text),
            ),

            const SizedBox(height: AppSizes.spacingXL),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.back, style: AppTextStyles.linkButton(context)),
              ),
            ),
            const SizedBox(height: AppSizes.spacingHuge),
          ],
        ),
      ),
    );
  }
}
