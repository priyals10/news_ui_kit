import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/img_1.png",
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
    {
      "image": "assets/images/img_2.png",
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
    {
      "image": "assets/images/img_3.png",
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Navigate to Login");
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            /// PAGE VIEW
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    image: pages[index]["image"]!,
                    title: pages[index]["title"]!,
                    description: pages[index]["desc"]!,
                  );
                },
              ),
            ),

            /// BOTTOM SECTION (Dots + Buttons)
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 32, 
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey.shade400,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),

                  Row(
                    children: [
                      if (currentIndex > 0)
                        TextButton(
                          onPressed: previousPage,
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),

                      const SizedBox(width: 8),

                      ElevatedButton(
                        onPressed: nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32, // wider
                            vertical: 16,   // taller
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          currentIndex == pages.length - 1
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
