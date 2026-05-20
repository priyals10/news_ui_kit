import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_state.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/latest_article_tile.dart';

class LatestScreen extends StatelessWidget {
  const LatestScreen({super.key});

  static final List<String> _categories = [
    AppStrings.all,
    AppStrings.sports,
    AppStrings.politics,
    AppStrings.business,
    AppStrings.health,
    AppStrings.travel,
    AppStrings.science,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.latest, style: AppTextStyles.headingSmall(context)),
        centerTitle: false,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is! NewsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ── Category chips ──
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPaddingH,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == state.selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<NewsBloc>()
                              .add(FetchHeadlinesByCategory(cat));
                        },
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── Article grid/list ──
              Expanded(
                child: state.isLatestLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.latestArticles.isEmpty
                        ? Center(
                            child: Text(
                              'No articles found',
                              style: AppTextStyles.greyText(context),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (width > 900) {
                                return GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.screenPaddingH,
                                    vertical: 8,
                                  ),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    mainAxisExtent: 130, // Tall enough for vertical tile
                                  ),
                                  itemCount: state.latestArticles.length,
                                  itemBuilder: (context, index) {
                                    final article = state.latestArticles[index];
                                    return LatestArticleTile(
                                      article: article,
                                      onTap: () => Navigator.pushNamed(
                                        context, AppRouter.articleDetail, arguments: article),
                                    );
                                  },
                                );
                              } else if (width > 600) {
                                return GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.screenPaddingH,
                                    vertical: 8,
                                  ),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    mainAxisExtent: 130,
                                  ),
                                  itemCount: state.latestArticles.length,
                                  itemBuilder: (context, index) {
                                    final article = state.latestArticles[index];
                                    return LatestArticleTile(
                                      article: article,
                                      onTap: () => Navigator.pushNamed(
                                        context, AppRouter.articleDetail, arguments: article),
                                    );
                                  },
                                );
                              } else {
                                return ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.screenPaddingH,
                                    vertical: 8,
                                  ),
                                  itemCount: state.latestArticles.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final article = state.latestArticles[index];
                                    return LatestArticleTile(
                                      article: article,
                                      onTap: () => Navigator.pushNamed(
                                        context, AppRouter.articleDetail, arguments: article),
                                    );
                                  },
                                );
                              }
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
