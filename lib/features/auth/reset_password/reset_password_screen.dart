import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
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
            Navigator.pushReplacementNamed(context, AppRouter.resetSuccess);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacingXL),
                    Text(AppStrings.resetPasswordTitle, style: AppTextStyles.headingMedium(context)),
                    const SizedBox(height: AppSizes.spacingXXL),

                    AuthTextField(
                      label: AppStrings.newPassword,
                      controller: newPasswordController,
                      isPassword: true,
                      errorText: state.newPasswordError,
                    ),

                    AuthTextField(
                      label: AppStrings.confirmNewPassword,
                      controller: confirmPasswordController,
                      isPassword: true,
                      errorText: state.confirmPasswordError,
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            ResetPasswordSubmitted(
                              newPassword: newPasswordController.text.trim(),
                              confirmPassword: confirmPasswordController.text.trim(),
                            ),
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
