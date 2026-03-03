import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_button.dart';
import 'package:news_ui_kit/core/widgets/app_search_field.dart';

class NewsSource {
  final String name;
  final String logo;
  bool isFollowing;

  NewsSource({required this.name, required this.logo, this.isFollowing = false});
}

class ChooseNewsSourceScreen extends StatefulWidget {
  const ChooseNewsSourceScreen({super.key});

  @override
  State<ChooseNewsSourceScreen> createState() => _ChooseNewsSourceScreenState();
}

class _ChooseNewsSourceScreenState extends State<ChooseNewsSourceScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<NewsSource> sources = [
    NewsSource(name: "CNBC", logo: AppAssets.cnbc),
    NewsSource(name: "VICE", logo: AppAssets.vice),
    NewsSource(name: "Vox", logo: AppAssets.vox),
    NewsSource(name: "BBC News", logo: AppAssets.bbc),
    NewsSource(name: "SCMP", logo: AppAssets.scmp),
    NewsSource(name: "CNN", logo: AppAssets.cnn),
    NewsSource(name: "MSN", logo: AppAssets.msn),
    NewsSource(name: "CNET", logo: AppAssets.cnet),
    NewsSource(name: "USA Today", logo: AppAssets.usaToday),
  ];

  List<NewsSource> filteredSources = [];

  @override
  void initState() {
    super.initState();
    filteredSources = sources;
    searchController.addListener(_filterSources);
  }

  void _filterSources() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredSources = sources
          .where((source) => source.name.toLowerCase().contains(query))
          .toList();
    });
  }

  bool get hasSelection => sources.any((s) => s.isFollowing);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingHSmall),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingXL),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.chooseYourNewsSources,
                        style: AppTextStyles.headingSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: AppSizes.spacingXL),

              AppSearchField(
                controller: searchController,
                borderColor: AppColors.primary,
                borderRadius: AppSizes.radiusXL,
                height: 55,
              ),

              const SizedBox(height: 25),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacingXL),
                  itemCount: filteredSources.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSizes.spacingL,
                    mainAxisSpacing: AppSizes.spacingXL,
                    mainAxisExtent: 210,
                  ),
                  itemBuilder: (context, index) {
                    final source = filteredSources[index];

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(AppSizes.radiusXXL),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: AppColors.cardInner,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusXXL),
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.asset(
                                      source.logo,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacingM),
                              Text(source.name, textAlign: TextAlign.center, style: AppTextStyles.sourceName),
                              const SizedBox(height: AppSizes.spacingM),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    source.isFollowing = !source.isFollowing;
                                  });
                                },
                                child: Container(
                                  width: 95,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: source.isFollowing ? AppColors.primary : AppColors.white,
                                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Center(
                                    child: Text(
                                      source.isFollowing ? AppStrings.following : AppStrings.follow,
                                      style: source.isFollowing
                                          ? AppTextStyles.followingButton
                                          : AppTextStyles.followButton,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              AppButton(
                text: AppStrings.next,
                isEnabled: hasSelection,
                onPressed: () {
                  final country = ModalRoute.of(context)?.settings.arguments as String? ?? '';
                  Navigator.pushNamed(
                    context,
                    AppRouter.fillProfile,
                    arguments: country,
                  );
                },
              ),

              const SizedBox(height: AppSizes.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
