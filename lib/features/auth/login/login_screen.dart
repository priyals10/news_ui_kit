import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/features/auth/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('remember_me', rememberMe);
            await prefs.setBool('has_seen_onboarding', true);
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, AppRouter.home);
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
                    Text(AppStrings.hello, style: AppTextStyles.headingLarge(context)),
                    Text(AppStrings.again, style: AppTextStyles.headingLargePrimary(context)),
                    const SizedBox(height: AppSizes.spacingM),
                    Text(AppStrings.welcomeBack, style: AppTextStyles.bodyLarge(context)),
                    const SizedBox(height: AppSizes.spacingHuge),

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

                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: AppColors.primary,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              Text(AppStrings.rememberMe, style: AppTextStyles.bodyMedium(context)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.forgotPassword);
                            },
                            child: Text(AppStrings.forgotThePassword, style: AppTextStyles.linkButton(context)),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : () {
                          context.read<AuthBloc>().add(
                            LoginSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        child: state.isLoading 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) 
                            : const Text(AppStrings.login),
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
                        onTap: () => Navigator.pushNamed(context, AppRouter.signup),
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.dontHaveAccount,
                            style: AppTextStyles.greyText(context),
                            children: [
                              TextSpan(text: AppStrings.signUp, style: AppTextStyles.link(context)),
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
    );
  }
}
