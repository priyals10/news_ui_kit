import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/home/data/repositories/bookmark_repository.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Bookmark',
          style: AppTextStyles.headingSmall(
            context,
          ).copyWith(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingH,
              vertical: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<NewsArticle>>(
              stream: _bookmarkRepository.getBookmarksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allBookmarks = snapshot.data ?? [];

                // Filter bookmarks based on search query
                final bookmarks =
                    _searchQuery.isEmpty
                        ? allBookmarks
                        : allBookmarks.where((article) {
                          return article.title.toLowerCase().contains(
                                _searchQuery,
                              ) ||
                              article.sourceName.toLowerCase().contains(
                                _searchQuery,
                              );
                        }).toList();

                if (bookmarks.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No bookmarks yet.'
                          : 'No articles found.',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                  itemCount: bookmarks.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final article = bookmarks[index];
                    return _buildBookmarkItem(article, colorScheme);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(NewsArticle article, ColorScheme colorScheme) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.articleDetail,
          arguments: article,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          // Content Left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Europe', // Placeholder for actual category if available
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      backgroundImage:
                          article.url.isNotEmpty
                              ? CachedNetworkImageProvider(
                                'https://www.google.com/s2/favicons?domain=${Uri.tryParse(article.url)?.host ?? ""}&sz=128',
                              )
                              : null,
                      child:
                          article.url.isEmpty
                              ? const Icon(Icons.public, size: 12)
                              : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      article.sourceName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      article.timeAgo,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Thumbnail Right
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                article.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            width: 96,
                            height: 96,
                            color: colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 96,
                            height: 96,
                            color: colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image),
                          ),
                    )
                    : Container(
                      width: 96,
                      height: 96,
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.article),
                    ),
          ),
        ],
      ),
    );
  }
}
