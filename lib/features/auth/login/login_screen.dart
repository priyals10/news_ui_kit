import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/utils/preferences_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            await PreferencesHelper.setRememberMe(rememberMe);
            await PreferencesHelper.setHasSeenOnboarding(true);
            if (context.mounted) {
              if (state.hasProfile) {
                // Already has a profile, go home
                Navigator.pushReplacementNamed(context, AppRouter.home);
              } else {
                // Profile missing, force setup flow as requested
                Navigator.pushReplacementNamed(context, AppRouter.selectCountry);
              }
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
                Text(AppStrings.hello, style: AppTextStyles.headingLarge(context)),
                Text(AppStrings.again, style: AppTextStyles.headingLargePrimary(context)),
                const SizedBox(height: AppSizes.spacingM),
                Text(AppStrings.welcomeBack, style: AppTextStyles.bodyLarge(context)),
                const SizedBox(height: AppSizes.spacingHuge),

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

                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: AppColors.primary,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) => setState(() => rememberMe = value!),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                AppStrings.rememberMe, 
                                style: AppTextStyles.bodyMedium(context),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.forgotThePassword, 
                            style: AppTextStyles.linkButton(context),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppPrimaryButton(
                  text: AppStrings.login,
                  isLoading: state.isLoading,
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      LoginSubmitted(
                        email: emailController.text,
                        password: passwordController.text,
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
          );
        },
      ),
    );
  }
}
