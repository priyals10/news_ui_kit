import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
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

    // Restored to the original 3 second splash delay
    const splashDuration = Duration(seconds: 3);

    Future.delayed(splashDuration, () async {
      if (!mounted) {
        return;
      }

      final rememberMe = await PreferencesHelper.getRememberMe();

      // If the user explicitly unchecked "Remember Me" in their last session, sign them out.
      if (!rememberMe) {
        await FirebaseAuth.instance.signOut();
      }

      // Small delay to ensure FirebaseAuth state is synchronized after a possible signOut
      final hasSeenOnboarding = await PreferencesHelper.getHasSeenOnboarding();
      
      // On Web, Firebase takes a moment to restore session. 
      // We check the first emit of authStateChanges if currentUser is null.
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null && kIsWeb) {
         user = await FirebaseAuth.instance.authStateChanges().first.timeout(
           const Duration(seconds: 1), 
           onTimeout: () => null,
         );
      }
      final isLoggedIn = user != null;

      if (mounted) {
        // Navigation priority:
        // 1. If NOT seen onboarding -> Onboarding
        // 2. Else if NOT logged in -> Login
        // 3. Else if NOT completed setup -> Select Country (Start flow)
        // 4. Else -> Home
        
        String nextRoute;
        if (!hasSeenOnboarding) {
          nextRoute = AppRouter.onboarding;
        } else if (!isLoggedIn) {
          nextRoute = AppRouter.login;
        } else {
          nextRoute = AppRouter.home;
        }
            
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
