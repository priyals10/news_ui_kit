import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing image header ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CircleAvatar(
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                child: Icon(Icons.arrow_back_ios_new, size: 18, color: colorScheme.onSurface),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  article.imageUrl.isNotEmpty
                      ? Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(Icons.broken_image, color: colorScheme.outline, size: 48),
                            ),
                          ),
                        )
                      : ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(Icons.article, color: colorScheme.outline, size: 48),
                          ),
                        ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 120,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Article content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingL),

                  // Date
                  if (article.publishedAt != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: colorScheme.outline),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('MMM d, yyyy').format(article.publishedAt!),
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: AppSizes.spacingL),

                  // Source row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        backgroundImage: article.url.isNotEmpty 
                            ? NetworkImage('https://www.google.com/s2/favicons?domain=${Uri.tryParse(article.url)?.host ?? ""}&sz=128') 
                            : null,
                        child: article.url.isEmpty ? Icon(Icons.public, size: 14, color: colorScheme.outline) : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article.sourceName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (article.author.isNotEmpty) ...[
                        Text(' · ', style: TextStyle(color: colorScheme.outline)),
                        Flexible(
                          child: Text(
                            article.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacingXL),

                  // Description
                  if (article.description.isNotEmpty)
                    Text(
                      article.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: colorScheme.onSurface.withValues(alpha: 0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: AppSizes.spacingL),

                  // Content
                  if (article.content.isNotEmpty)
                    Text(
                      article.content,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                  const SizedBox(height: AppSizes.spacingHuge),

                  // Read Full Article Button
                  if (article.url.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(article.url);
                          try {
                            final launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                            if (!launched && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open the article.')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open the article.')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Read more'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSizes.spacingHuge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
