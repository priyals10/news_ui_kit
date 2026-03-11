import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/features/auth/widgets/social_button.dart';

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
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('has_seen_onboarding', true);
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, AppRouter.selectCountry, (route) => false);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacingHuge),
                    Text(AppStrings.helloExclaim, style: AppTextStyles.headingLargePrimary(context)),
                    const SizedBox(height: AppSizes.spacingSM),
                    Text(AppStrings.signupToGetStarted, style: AppTextStyles.bodyLarge(context)),
                    const SizedBox(height: 50),

                    AuthTextField(
                      label: AppStrings.email,
                      controller: emailController,
                      errorText: state.emailError,
                    ),

                    AuthTextField(
                      label: AppStrings.password,
                      controller: passwordController,
                      isPassword: true,
                      errorText: state.passwordError,
                    ),

                    AuthTextField(
                      label: AppStrings.confirmPassword,
                      controller: confirmPasswordController,
                      isPassword: true,
                      errorText: state.confirmPasswordError,
                    ),

                    const SizedBox(height: AppSizes.spacingXL),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : () {
                          context.read<AuthBloc>().add(
                            SignupSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            ),
                          );
                        },
                        child: state.isLoading 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) 
                            : const Text(AppStrings.signUp),
                      ),
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
                        SocialButton(text: AppStrings.facebook, iconPath: AppAssets.fbIcon, onPressed: () {}),
                        const SizedBox(width: AppSizes.spacingM),
                        SocialButton(text: AppStrings.google, iconPath: AppAssets.googleIcon, onPressed: () {}),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
