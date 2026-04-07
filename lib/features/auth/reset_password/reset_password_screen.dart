import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
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
            Text(AppStrings.resetPasswordTitle, style: AppTextStyles.headingLarge(context)),
            const SizedBox(height: 50),

            AppTextField(
              label: AppStrings.newPassword,
              controller: newPasswordController,
              isPassword: true,
            ),

            AppTextField(
              label: AppStrings.confirmNewPassword,
              controller: confirmNewPasswordController,
              isPassword: true,
            ),

            const SizedBox(height: AppSizes.spacingXL),

            AppPrimaryButton(
              text: AppStrings.submit,
              onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.resetSuccess),
            ),
            const SizedBox(height: AppSizes.spacingHuge),
          ],
        ),
      ),
    );
  }
}
