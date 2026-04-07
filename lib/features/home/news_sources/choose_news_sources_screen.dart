import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

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
  final ScrollController _scrollController = ScrollController();

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
      filteredSources = sources.where((source) => source.name.toLowerCase().contains(query)).toList();
    });
  }

  bool get hasSelection => sources.any((s) => s.isFollowing);

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WebConstrainedLayout(
        maxWidth: 800,
        scrollable: false,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingXL),
            Text(AppStrings.chooseYourNewsSources, style: AppTextStyles.headingSmall(context)),
            const SizedBox(height: AppSizes.spacingXL),
            AppTextField(
              label: AppStrings.search,
              controller: searchController,
              isRequired: false,
              hintText: 'Search for sources',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                itemCount: filteredSources.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final source = filteredSources[index];
                  return Column(
                    children: [
                      ClipOval(
                        child: Image.asset(source.logo, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 8),
                      Text(source.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          onPressed: () => setState(() => source.isFollowing = !source.isFollowing),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: source.isFollowing ? AppColors.primary : Colors.transparent,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Text(
                            source.isFollowing ? AppStrings.following : AppStrings.follow,
                            style: TextStyle(color: source.isFollowing ? Colors.white : AppColors.primary, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              text: AppStrings.next,
              onPressed: hasSelection ? () {
                final country = ModalRoute.of(context)?.settings.arguments as String? ?? '';
                Navigator.pushNamed(context, AppRouter.fillProfile, arguments: country);
              } : null,
            ),
            const SizedBox(height: AppSizes.spacingXL),
          ],
        ),
      ),
    );
  }
}
