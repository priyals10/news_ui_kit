import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String contact;

  const OtpVerificationScreen({super.key, required this.contact});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget buildOtpBox(int index, String? otpError) {
    return SizedBox(
      width: AppSizes.otpBoxSize,
      height: AppSizes.otpBoxSize,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        textAlign: TextAlign.center,
        style: AppTextStyles.otpDigit(context),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            borderSide: BorderSide(
              color: otpError != null ? AppColors.error : AppColors.greyBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            borderSide: BorderSide(
              color: otpError != null ? AppColors.error : AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushNamed(context, AppRouter.resetPassword);
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
                  children: [
                    const SizedBox(height: AppSizes.spacingXL),
                    Text(AppStrings.otpVerification, style: AppTextStyles.headingOtp(context)),
                    const SizedBox(height: AppSizes.spacingSM),

                    Text(
                      "${AppStrings.enterOtpSentTo}${widget.contact}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(context),
                    ),

                    const SizedBox(height: AppSizes.spacingXXL),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: buildOtpBox(index, state.otpError),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingS),

                    if (state.otpError != null)
                      Text(state.otpError!, style: AppTextStyles.error(context)),

                    const SizedBox(height: AppSizes.spacingXL),

                    RichText(
                      text: TextSpan(
                        text: AppStrings.resendCodeIn,
                        style: AppTextStyles.bodySmall(context),
                        children: [
                          TextSpan(
                            text: "${secondsRemaining}s",
                            style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            OtpSubmitted(
                              otpDigits: controllers.map((c) => c.text).toList(),
                            ),
                          );
                        },
                        child: const Text(AppStrings.verify),
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
