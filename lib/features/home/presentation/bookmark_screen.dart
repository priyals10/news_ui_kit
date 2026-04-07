import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/latest_article_tile.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';
import 'package:news_ui_kit/core/router/app_router.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return WebConstrainedLayout(
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: Text(
              "Bookmark", 
              style: AppTextStyles.headingLarge(context).copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH, vertical: 8),
            child: TextField(
              onChanged: (query) => context.read<BookmarkBloc>().add(SearchBookmarks(query)),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, state) {
                if (state.isLoading && state.bookmarks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null && state.bookmarks.isEmpty) {
                  return Center(child: Text(state.error!));
                }

                final bookmarks = state.filteredBookmarks;

                if (bookmarks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        state.filterQuery.isEmpty ? AppStrings.noBookmarksFound : 'No articles found for "${state.filterQuery}"',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.greyText(context),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                  itemCount: bookmarks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final article = bookmarks[index];
                    return LatestArticleTile(
                      article: article,
                      onTap: () => Navigator.pushNamed(context, AppRouter.articleDetail, arguments: article),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
