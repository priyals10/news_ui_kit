import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

class TrendingCard extends StatelessWidget {
  final NewsArticle article;
  final double? width;
  final double? height;

  const TrendingCard({
    super.key,
    required this.article,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.textBlack,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ──
          if (article.imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: article.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.greyDark.withValues(alpha: 0.3),
              ),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.greyDark,
                child: Center(
                  child: Icon(Icons.broken_image, color: AppColors.white, size: 40),
                ),
              ),
            ),

          // ── Gradient overlay ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.3, 1.0],
              ),
            ),
          ),

          // ── Text content ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                // Title
                Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Source + time
                Row(
                  children: [
                    // Source icon
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.greyDark,
                      child: Icon(Icons.public, size: 12, color: AppColors.white),
                    ),
                    const SizedBox(width: 6),
                    // Source name
                    Flexible(
                      child: Text(
                        article.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.greyLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Time ago
                    Text(
                      article.timeAgo,
                      style: const TextStyle(
                        color: AppColors.greyLight,
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
    );
  }
}
