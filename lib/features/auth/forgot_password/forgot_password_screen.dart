import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';

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
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.validatedContact != null) {
            Navigator.pushNamed(
              context,
              AppRouter.otpVerification,
              arguments: state.validatedContact!,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacingMD),
                    const Text(AppStrings.forgotPasswordTitle, style: AppTextStyles.headingMedium),
                    const SizedBox(height: AppSizes.spacingM),
                    const Text(AppStrings.forgotPasswordDesc, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSizes.spacingXL),

                    AuthTextField(
                      label: AppStrings.emailOrMobile,
                      controller: emailController,
                      errorText: state.emailError,
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            ForgotPasswordSubmitted(emailOrMobile: emailController.text),
                          );
                        },
                        child: const Text(AppStrings.submit),
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingXL),
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
