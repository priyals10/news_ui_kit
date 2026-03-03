import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacementNamed(context, AppRouter.selectCountry);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacingHuge),
                    const Text(AppStrings.helloExclaim, style: AppTextStyles.headingLargePrimary),
                    const SizedBox(height: AppSizes.spacingSM),
                    const Text(AppStrings.signupToGetStarted, style: AppTextStyles.bodyLarge),
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
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            SignupSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            ),
                          );
                        },
                        child: const Text(AppStrings.signUp),
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingMD),
                    const Center(
                      child: Text(
                        AppStrings.orContinueWith,
                        style: TextStyle(fontSize: 16, color: AppColors.textBlack),
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
                          text: const TextSpan(
                            text: AppStrings.alreadyHaveAccount,
                            style: AppTextStyles.greyText,
                            children: [
                              TextSpan(text: AppStrings.login, style: AppTextStyles.link),
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
