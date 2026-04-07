import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/core/utils/image_cache_manager.dart';

class LatestArticleTile extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const LatestArticleTile({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Thumbnail ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: article.proxiedImageUrl,
                  cacheKey: article.imageUrl,
                  fit: BoxFit.cover,
                  cacheManager: CustomCacheManager.instance,
                  errorWidget: (_, __, ___) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // --- Text Content ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // SOURCE (Kabar Style Badge)
                  Text(
                    article.sourceName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // TITLE
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // TIME
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        article.timeAgo,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 12,
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
