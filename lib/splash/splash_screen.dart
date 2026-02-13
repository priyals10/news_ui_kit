import 'package:flutter/material.dart';
import 'package:news_ui_kit/onboarding/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 1),

          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 270,
            ),
          ),

          const Spacer(flex: 3),
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
