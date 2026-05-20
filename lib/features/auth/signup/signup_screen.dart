import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/utils/preferences_helper.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state.isSuccess) {
              await PreferencesHelper.setHasSeenOnboarding(true);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.selectCountry, (route) => false);
              }
            }
          },
          builder: (context, state) {
            return WebConstrainedLayout(
              maxWidth: 500,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.spacingHuge),
                  Text(AppStrings.helloExclaim, style: AppTextStyles.headingLargePrimary(context)),
                  const SizedBox(height: AppSizes.spacingSM),
                  Text(AppStrings.signupToGetStarted, style: AppTextStyles.bodyLarge(context)),
                  const SizedBox(height: 50),

                  AppTextField(
                    label: AppStrings.email,
                    controller: emailController,
                    errorText: state.emailError,
                  ),

                  AppTextField(
                    label: AppStrings.password,
                    controller: passwordController,
                    isPassword: true,
                    errorText: state.passwordError,
                  ),

                  AppTextField(
                    label: AppStrings.confirmPassword,
                    controller: confirmPasswordController,
                    isPassword: true,
                    errorText: state.confirmPasswordError,
                  ),

                  const SizedBox(height: AppSizes.spacingXL),

                  AppPrimaryButton(
                    text: AppStrings.signUp,
                    isLoading: state.isLoading,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignupSubmitted(
                          email: emailController.text,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSizes.spacingMD),
                  Center(
                    child: Text(
                      AppStrings.orContinueWith,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingS),

                  Row(
                    children: [
                      AppSocialButton(text: AppStrings.facebook, iconPath: AppAssets.fbIcon, onPressed: () {}),
                      const SizedBox(width: AppSizes.spacingM),
                      AppSocialButton(text: AppStrings.google, iconPath: AppAssets.googleIcon, onPressed: () {}),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacingXL),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.greyText(context),
                          children: [
                            TextSpan(text: AppStrings.login, style: AppTextStyles.link(context)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingHuge),
                ],
              ),
            );
          },
      ),
    );
  }
}
