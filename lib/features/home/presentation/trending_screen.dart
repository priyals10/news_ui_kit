import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

class TrendingScreen extends StatelessWidget {
  final List<NewsArticle> articles;

  const TrendingScreen({super.key, required this.articles});

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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 20),
        ),
        title: Text(
          AppStrings.trending,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (width > 900) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.spacingL,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 32,
                mainAxisExtent: 380,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context, AppRouter.articleDetail, arguments: article),
                  child: _TrendingListCard(article: article),
                );
              },
            );
          } else if (width > 600) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.spacingL,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 32,
                mainAxisExtent: 380,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context, AppRouter.articleDetail, arguments: article),
                  child: _TrendingListCard(article: article),
                );
              },
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.spacingL,
              ),
              itemCount: articles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context, AppRouter.articleDetail, arguments: article),
                  child: _TrendingListCard(article: article),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _TrendingListCard extends StatelessWidget {
  final NewsArticle article;

  const _TrendingListCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: article.imageUrl.isNotEmpty
                ? Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(Icons.broken_image, size: 40, color: colorScheme.outline),
                      ),
                    ),
                  )
                : Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(Icons.article, size: 40, color: colorScheme.outline),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Icon(Icons.public, size: 12, color: colorScheme.outline),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                article.sourceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.access_time, size: 14, color: colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              article.timeAgo,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.outline,
              ),
            ),
            const Spacer(),
            Icon(Icons.more_horiz, size: 20, color: colorScheme.outline),
          ],
        ),
      ],
    );
  }
}
