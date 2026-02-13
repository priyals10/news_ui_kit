import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // top bar color
        statusBarIconBrightness: Brightness.dark, // dark icons
        systemNavigationBarColor: Colors.white, // bottom bar color
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true, 
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Full white background
          Positioned.fill(
            child: Container(color: Colors.white),
          ),

          /// Centered Logo
          Align(
            alignment: const Alignment(0, -0.4),
            child: Image.asset(
              'assets/images/logo.png',
              width: 270,
            ),
          ),
        ],
      ),
    );
  }
}










// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const Spacer(flex: 1),
//
//           Center(
//             child: Image.asset(
//               'assets/images/logo.png',
//               width: 270,
//             ),
//           ),
//
//           const Spacer(flex: 3),
//         ],
//       ),
//     );
//   }
// }
