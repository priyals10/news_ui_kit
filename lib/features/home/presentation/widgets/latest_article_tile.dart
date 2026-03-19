import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

/// A horizontal tile showing a latest news article.
/// Layout: left side (square thumbnail) — right side (title, source + time).
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              child: article.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 96,
                        height: 96,
                        color: AppColors.greyLight,
                        child: const Icon(Icons.image, color: AppColors.greyHint),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 96,
                        height: 96,
                        color: AppColors.greyLight,
                        child: const Icon(Icons.broken_image, color: AppColors.greyHint),
                      ),
                    )
                  : Container(
                      width: 96,
                      height: 96,
                      color: AppColors.greyLight,
                      child: const Icon(Icons.image, color: AppColors.greyHint),
                    ),
            ),

            const SizedBox(width: 12),

            // ── Right: text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title — max 2 lines
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

                  // Source + time
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          article.sourceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.circle, size: 4, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                      Text(
                        article.timeAgo,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.greyDark,
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
