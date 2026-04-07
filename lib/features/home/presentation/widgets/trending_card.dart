import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/core/utils/image_cache_manager.dart';

class TrendingCard extends StatefulWidget {
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
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.diagonal3Values(_isHovered ? 1.01 : 1.0, _isHovered ? 1.01 : 1.0, 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.2 : 0.1),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 10 : 4),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ──
            if (widget.article.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: widget.article.proxiedImageUrl,
                cacheKey: widget.article.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 800,
                cacheManager: CustomCacheManager.instance,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),

            // ── Gradient overlay (Better Contrast) ──
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // ── Text content ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Category Badge (Simulated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.article.sourceName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Title
                  Text(
                    widget.article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bottom Info
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        widget.article.timeAgo,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.more_horiz, color: Colors.white70),
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
