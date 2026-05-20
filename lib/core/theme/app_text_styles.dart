import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';


class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle headingLarge(BuildContext context) => TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headingLargePrimary(BuildContext context) => TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle headingMedium(BuildContext context) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headingSmall(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headingOtp(BuildContext context) => TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
      color: Theme.of(context).colorScheme.onSurface,
      );

  // Body text
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: 17,
        height: 1.4,
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontSize: 16,
      color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: 14,
      color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface,
      );

  // Button
  static TextStyle buttonText(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  static const TextStyle buttonTextMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // Link / interactive
  static TextStyle link(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle linkButton(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  // Label
  static TextStyle label(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle labelSmall(BuildContext context) => TextStyle(
        fontSize: 14,
      color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface,
      );

  // Grey hint text
  static TextStyle greyText(BuildContext context) => TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 14,
      );

  static TextStyle greyButton(BuildContext context) => TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 16,
      );

  // Social button
  static TextStyle socialButton(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
      );

  // List item
  static TextStyle listItem(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle listItemSelected(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  // Topic chip
  static TextStyle chipText(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle chipTextSelected(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  // News source
  static TextStyle sourceName(BuildContext context) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle followButton(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle followingButton(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  // Onboarding
  static TextStyle onboardingTitle(BuildContext context) => TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
      color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle onboardingDesc(BuildContext context) => TextStyle(
        fontSize: 16,
        color: Theme.of(context).hintColor,
      );

  // OTP digit input
  static TextStyle otpDigit(BuildContext context) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      );

  // Error
  static TextStyle error(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 14,
      );
  }
