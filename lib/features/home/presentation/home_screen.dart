import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_state.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/trending_card.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/latest_article_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = [
    AppStrings.all,
    AppStrings.sports,
    AppStrings.politics,
    AppStrings.business,
    AppStrings.health,
    AppStrings.travel,
    AppStrings.science,
  ];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<NewsBloc>();
    bloc.add(const FetchTopHeadlines());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NewsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: AppSizes.spacingL),
                    ElevatedButton(
                      onPressed: () => context.read<NewsBloc>().add(const FetchTopHeadlines()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is NewsLoaded) {
            return _buildContent(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 1,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/images/logo.png',
          height: 90,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: () {
              // Notification tap — future feature
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colorScheme.onSurface,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildContent(NewsLoaded state) {
    // Show up to 5 articles in horizontal scroll
    final trendingArticles = state.articles.take(5).toList();
    final latestArticles = state.latestArticles.take(5).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spacingL),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.searchNews);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.search,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.tune_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 22),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacingXL),

          // ── Section header: Trending + See all ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.trending, style: AppTextStyles.headingSmall(context)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.trending,
                      arguments: state.articles,
                    );
                  },
                  child: Text(
                    AppStrings.seeAll,
                    style: AppTextStyles.linkButton(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingL),

          // ── Horizontal scrollable trending cards ──
          SizedBox(
            height: 250,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              scrollDirection: Axis.horizontal,
              itemCount: trendingArticles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.articleDetail,
                      arguments: trendingArticles[index],
                    );
                  },
                  child: TrendingCard(
                    article: trendingArticles[index],
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.spacingXL),

          // ── Section header: Latest + See all ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.latest, style: AppTextStyles.headingSmall(context)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.latest);
                  },
                  child: Text(
                    AppStrings.seeAll,
                    style: AppTextStyles.linkButton(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingM),

          // ── Category labels ──
          SizedBox(
            height: 32,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == state.selectedCategory;
                return GestureDetector(
                  onTap: () {
                    context.read<NewsBloc>().add(FetchHeadlinesByCategory(cat));
                  },
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? AppColors.primary : AppColors.greyDark,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.spacingL),

          // ── Latest articles list ──
          if (state.isLatestLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (latestArticles.isEmpty && state.selectedCategory != 'All')
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: 32,
              ),
              child: Center(
                child: Text(
                  'No articles found for this category',
                  style: AppTextStyles.greyText(context),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: latestArticles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return LatestArticleTile(
                    article: latestArticles[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.articleDetail,
                        arguments: latestArticles[index],
                      );
                    },
                  );
                },
              ),
            ),

          const SizedBox(height: AppSizes.spacingXL),
        ],
      ),
    );
  }
}
