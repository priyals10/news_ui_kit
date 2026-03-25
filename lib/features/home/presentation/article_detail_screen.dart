import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_event.dart';


class ArticleDetailScreen extends StatefulWidget {
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    // No need to manual dispatch LoadBookmarks as it auto-starts in Bloc constructor
  }

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
            systemOverlayStyle: SystemUiOverlayStyle.light,
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
            actions: [
              if (widget.article.sourceId.isNotEmpty && widget.article.url.isEmpty)
                CircleAvatar(
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                  child: IconButton(
                    icon: Icon(Icons.more_vert, color: colorScheme.onSurface, size: 20),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                        builder: (bottomSheetContext) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit, color: colorScheme.onSurface),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(bottomSheetContext);
                                  final userNews = UserNewsModel(
                                    id: widget.article.sourceId,
                                    authorId: FirebaseAuth.instance.currentUser?.uid ?? '',
                                    authorName: widget.article.sourceName,
                                    authorImage: '', 
                                    title: widget.article.title,
                                    content: widget.article.content,
                                    coverImageUrl: widget.article.imageUrl,
                                    createdAt: widget.article.publishedAt ?? DateTime.now(),
                                  );
                                  Navigator.pushNamed(context, AppRouter.createNews, arguments: userNews).then((_) {
                                    if (context.mounted) Navigator.pop(context, true);
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete, color: Colors.red),
                                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                                onTap: () async {
                                  Navigator.pop(bottomSheetContext);
                                  
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete News'),
                                      content: const Text('Are you sure you want to delete this news post?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('Delete', style: TextStyle(color: colorScheme.error)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true && context.mounted) {
                                    context.read<CreateNewsBloc>().add(DeleteNews(newsId: widget.article.sourceId));
                                    if (context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.article.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.article.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => ColoredBox(
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
                    widget.article.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingL),

                  // Date
                  if (widget.article.publishedAt != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: colorScheme.outline),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('MMM d, yyyy').format(widget.article.publishedAt!),
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
                        backgroundImage: widget.article.url.isNotEmpty 
                            ? CachedNetworkImageProvider('https://www.google.com/s2/favicons?domain=${Uri.tryParse(widget.article.url)?.host ?? ""}&sz=128') 
                            : null,
                        child: widget.article.url.isEmpty ? Icon(Icons.public, size: 14, color: colorScheme.outline) : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.article.sourceName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (widget.article.author.isNotEmpty) ...[
                        Text(' · ', style: TextStyle(color: colorScheme.outline)),
                        Flexible(
                          child: Text(
                            widget.article.author,
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
                  if (widget.article.description.isNotEmpty)
                    Text(
                      widget.article.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: colorScheme.onSurface.withValues(alpha: 0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: AppSizes.spacingL),

                  // Content
                  if (widget.article.content.isNotEmpty)
                    Text(
                      widget.article.content,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                  const SizedBox(height: AppSizes.spacingHuge),

                  // Read Full Article Button
                  if (widget.article.url.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(widget.article.url);
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant, width: 0.5)),
        ),
        child: SafeArea(
          child: BlocConsumer<BookmarkBloc, BookmarkState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Favorite failed: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              final isBookmarked = state.isBookmarked(widget.article);
              final isLoading = state.isLoading && state.bookmarks.isEmpty;

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          onPressed: () {
                            context.read<BookmarkBloc>().add(ToggleBookmark(widget.article));
                          },
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked ? Colors.blue : colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
