import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/utils/preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        // Use PreferencesHelper — not raw SharedPreferences
        final rememberMe = await PreferencesHelper.getRememberMe();

        if (!rememberMe) {
          await FirebaseAuth.instance.signOut();
        }

        final hasSeenOnboarding = await PreferencesHelper.getHasSeenOnboarding();

        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            isLoggedIn
              ? AppRouter.home
              : (hasSeenOnboarding ? AppRouter.login : AppRouter.onboarding),
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set system UI based on current theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? const Color(0xFF212121) : Colors.white,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: bgColor),
          ),
          Align(
            alignment: const Alignment(0, -0.4),
            child: Image.asset(
              AppAssets.logo,
              width: AppSizes.splashLogoWidth,
            ),
          ),
        ],
      ),
    );
  }
}
