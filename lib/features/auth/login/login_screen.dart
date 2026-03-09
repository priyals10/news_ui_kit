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
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
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
                              const Text(AppStrings.rememberMe, style: TextStyle(fontSize: 16)),
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
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        child: const Text(AppStrings.login),
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
      ),
    );
  }
}
