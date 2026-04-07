import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_assets.dart';
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
import 'package:news_ui_kit/core/utils/responsive.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';
import 'package:news_ui_kit/features/home/presentation/article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<NewsBloc>();
    if (bloc.state is! NewsLoaded) {
      bloc.add(const FetchTopHeadlines());
    }
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPaddingH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSizes.spacingL),
            Text(message, textAlign: TextAlign.center),
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

  double _feedWidthProportion = 0.4; // Default to 40/60 split

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
            return _buildError(state.message);
          }
          if (state is NewsLoaded) {
            final content = HomeNewsContent(state: state);
            if (context.isMobile) return content;

            final hasSelection = state.selectedArticle != null;

            return LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    // --- NEWS FEED SECTION ---
                    Expanded(
                      flex: hasSelection ? (_feedWidthProportion * 100).toInt() : 100,
                      child: content,
                    ),

                    if (hasSelection) ...[
                      // --- RESIZABLE DIVIDER ---
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (constraints.maxWidth > 0) {
                            setState(() {
                              // Calculate new proportion based on mouse movement
                              _feedWidthProportion += details.delta.dx / constraints.maxWidth;
                              // Keep it within reasonable bounds
                              _feedWidthProportion = _feedWidthProportion.clamp(0.2, 0.8);
                            });
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: Container(
                            width: 10,
                            color: Colors.transparent, // Invisible wider touch area
                            child: const VerticalDivider(
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ),

                      // --- ARTICLE DETAIL SECTION ---
                      Expanded(
                        flex: ((1 - _feedWidthProportion) * 100).toInt(),
                        child: ArticleDetailScreen(
                          key: ValueKey(state.selectedArticle!.title + state.selectedArticle!.sourceName),
                          article: state.selectedArticle!,
                          isEmbedded: true,
                        ),
                      ),
                    ],
                  ],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: context.isMobile ? 1 : 24,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset(
          AppAssets.logo,
          height: context.isMobile ? 90 : 110,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: () {},
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
}

class HomeNewsContent extends StatelessWidget {
  final NewsLoaded state;
  const HomeNewsContent({super.key, required this.state});

  void _onArticleTap(BuildContext context, NewsArticle article) {
    if (context.isMobile) {
      Navigator.pushNamed(
        context,
        AppRouter.articleDetail,
        arguments: article,
      );
    } else {
      context.read<NewsBloc>().add(SelectArticle(article));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = state.searchQuery.isNotEmpty;
    final searchResults = state.allSearchResults;

    final trendingArticles = state.articles.take(5).toList();
    final latestArticles = state.latestArticles.take(10).toList();

    return WebConstrainedLayout(
      maxWidth: 1200,
      padding: EdgeInsets.zero,
      scrollable: false,
      child: Column(
        children: [
          // Keep the search bar consistent to prevent focus loss
          const HomeSearchBar(),
          
          Expanded(
            child: isSearching
                ? (searchResults.isEmpty
                    ? Center(child: Text('No results found for "${state.searchQuery}"', style: AppTextStyles.greyText(context)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                        itemCount: searchResults.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _onArticleTap(context, searchResults[index]),
                            child: LatestArticleTile(article: searchResults[index]),
                          );
                        },
                      ))
                : CustomScrollView(
                    key: const PageStorageKey('home_news_scroll'),
                    slivers: [
                      // ── Trending Header ──

        // ── Trending Header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingH,
              vertical: AppSizes.spacingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.trending, style: AppTextStyles.headingSmall(context)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRouter.trending, arguments: state.articles),
                  child: Text(AppStrings.seeAll, style: AppTextStyles.linkButton(context)),
                ),
              ],
            ),
          ),
        ),

        // ── Trending Cards (Horizontal) ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              scrollDirection: Axis.horizontal,
              itemCount: trendingArticles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onArticleTap(context, trendingArticles[index]),
                  child: TrendingCard(
                    article: trendingArticles[index],
                    width: 400,
                  ),
                );
              },
            ),
          ),
        ),

        // ── Latest header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingH,
              vertical: AppSizes.spacingXL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.latest, style: AppTextStyles.headingSmall(context)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRouter.latest),
                  child: Text(AppStrings.seeAll, style: AppTextStyles.linkButton(context)),
                ),
              ],
            ),
          ),
        ),

        // ── Categories ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == state.selectedCategory;
                return GestureDetector(
                  onTap: () => context.read<NewsBloc>().add(FetchHeadlinesByCategory(cat)),
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
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingL)),

        // ── Latest articles (Adaptive Grid) ──
        if (state.isLatestLoading)
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()))
        else if (latestArticles.isEmpty && state.selectedCategory != 'All')
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No articles found', style: AppTextStyles.greyText(context))),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                mainAxisExtent: 140, // Increased for premium tile height
                mainAxisSpacing: 12,
                crossAxisSpacing: 32,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return LatestArticleTile(
                    article: latestArticles[index],
                    onTap: () => _onArticleTap(context, latestArticles[index]),
                  );
                },
                childCount: latestArticles.length,
              ),
            ),
          ),
        
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingXL)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static const List<String> _categories = [
    AppStrings.all, AppStrings.sports, AppStrings.politics,
    AppStrings.business, AppStrings.health, AppStrings.travel, AppStrings.science,
  ];
}

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with current query from bloc state if it exists
    final state = context.read<NewsBloc>().state;
    final currentQuery = state is NewsLoaded ? state.searchQuery : '';
    _controller = TextEditingController(text: currentQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPaddingH,
        vertical: AppSizes.spacingL,
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) => context.read<NewsBloc>().add(SearchHomeNews(value)),
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: AppStrings.search,
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: _controller.text.isEmpty
              ? Icon(Icons.tune_rounded, color: colorScheme.onSurfaceVariant, size: 22)
              : IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _controller.clear();
                    context.read<NewsBloc>().add(const SearchHomeNews(''));
                  },
                ),
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
