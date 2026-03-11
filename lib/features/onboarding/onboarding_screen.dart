import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/theme/app_theme.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(AppTheme.onboardingSystemUI);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> pages = [
    {
      "image": AppAssets.onboarding1,
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
    {
      "image": AppAssets.onboarding2,
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
    {
      "image": AppAssets.onboarding3,
      "title": "Lorem Ipsum is simply dummy",
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    },
  ];

  Future<void> nextPage() async {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
      if (mounted) Navigator.pushReplacementNamed(context, AppRouter.login);
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
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
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

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.screenPaddingH,
                right: AppSizes.screenPaddingH,
                bottom: AppSizes.spacingM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.greyBorder,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),

                  Row(
                    children: [
                      if (currentIndex > 0)
                        TextButton(
                          onPressed: previousPage,
                          child: Text(
                            AppStrings.back,
                            style: AppTextStyles.greyButton(context),
                          ),
                        ),

                      const SizedBox(width: AppSizes.spacingSM),

                      ElevatedButton(
                        onPressed: nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          currentIndex == pages.length - 1
                              ? AppStrings.getStarted
                              : AppStrings.next,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
