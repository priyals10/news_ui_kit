import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle headingLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: AppColors.textBlack,
  );

  static const TextStyle headingLargePrimary = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textBlack,
  );

  static const TextStyle headingOtp = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    height: 1.4,
    color: Colors.black87,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  // Button
  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );

  static const TextStyle buttonTextMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // Link / interactive
  static const TextStyle link = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle linkButton = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Label
  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  // Grey hint text
  static const TextStyle greyText = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  static const TextStyle greyButton = TextStyle(
    color: Colors.grey,
    fontSize: 16,
  );

  // Social button
  static const TextStyle socialButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );

  // List item
  static const TextStyle listItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle listItemSelected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // Topic chip
  static const TextStyle chipText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle chipTextSelected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // News source
  static const TextStyle sourceName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle followButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle followingButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Onboarding
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: AppColors.textBlack,
  );

  static const TextStyle onboardingDesc = TextStyle(
    fontSize: 16,
    color: AppColors.greyDark,
  );

  // OTP digit input
  static const TextStyle otpDigit = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  // Error
  static const TextStyle error = TextStyle(
    color: AppColors.error,
    fontSize: 14,
  );
}
