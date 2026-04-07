import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/core/utils/responsive.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_event.dart';
import 'package:news_ui_kit/core/utils/image_cache_manager.dart';


class ArticleDetailScreen extends StatefulWidget {
  final NewsArticle article;
  final bool isEmbedded;

  const ArticleDetailScreen({
    super.key,
    required this.article,
    this.isEmbedded = false,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = CustomScrollView(
      slivers: [
        // ── Collapsing image header (Only if not embedded or if we want a hero look) ──
        if (!widget.isEmbedded)
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
            flexibleSpace: _buildFlexibleSpace(colorScheme),
            actions: _buildAppBarActions(context, colorScheme),
          )
        else
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: _buildFlexibleSpace(colorScheme),
                ),
                // Close button for desktop/split-view
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      ..._buildOwnerActionButtons(context, colorScheme),
                      const SizedBox(width: 8),
                      // Integrated Bookmark for Desktop
                      BlocBuilder<BookmarkBloc, BookmarkState>(
                        builder: (context, state) {
                          final isBookmarked = state.isBookmarked(widget.article);
                          return CircleAvatar(
                            backgroundColor: Colors.black45,
                            child: IconButton(
                              onPressed: () => context.read<BookmarkBloc>().add(ToggleBookmark(widget.article)),
                              icon: Icon(
                                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                color: isBookmarked ? Colors.blue : Colors.white,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          onPressed: () => context.read<NewsBloc>().add(const ClearSelection()),
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // ── Article content ──
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: EdgeInsets.all(context.responsive(AppSizes.screenPaddingH, tablet: 40.0, desktop: 56.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.article.title,
                      style: TextStyle(
                        fontSize: context.responsive(22.0, tablet: 28.0, desktop: 32.0),
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingL),

                    // Source & Author
                    _buildMetaRow(colorScheme),

                    const SizedBox(height: AppSizes.spacingXL),

                    // Description
                    if (widget.article.description.isNotEmpty)
                      Text(
                        widget.article.description,
                        style: TextStyle(
                          fontSize: 18,
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
                          fontSize: 16,
                          height: 1.7,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                    const SizedBox(height: AppSizes.spacingHuge),

                    // Read Full Article Button
                    if (widget.article.url.isNotEmpty)
                      _buildReadMoreButton(colorScheme),

                    const SizedBox(height: AppSizes.spacingHuge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.isEmbedded) {
       return Container(
         color: colorScheme.surface,
         child: content,
       );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: content,
      bottomNavigationBar: _buildBottomBar(colorScheme),
    );
  }

  Widget _buildFlexibleSpace(ColorScheme colorScheme) {
     return Stack(
        fit: StackFit.expand,
        children: [
          widget.article.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: widget.article.proxiedImageUrl,
                  cacheKey: widget.article.imageUrl,
                  fit: BoxFit.cover,
                  cacheManager: CustomCacheManager.instance,
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
      );
  }

  Widget _buildMetaRow(ColorScheme colorScheme) {
    return Row(
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
    );
  }

  Widget _buildReadMoreButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(widget.article.url);
          try {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } catch (e) {
            if (mounted) {
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
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
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
      );
  }

  List<Widget> _buildAppBarActions(BuildContext context, ColorScheme colorScheme) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = widget.article.authorId.isNotEmpty && widget.article.authorId == currentUid;

    if (!isOwner) return [];

    return [
      IconButton(
        onPressed: () => _onEdit(context),
        icon: CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          child: Icon(Icons.edit_outlined, size: 18, color: colorScheme.onSurface),
        ),
      ),
      IconButton(
        onPressed: () => _onDelete(context),
        icon: CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          child: Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
        ),
      ),
      const SizedBox(width: 8),
    ];
  }

  List<Widget> _buildOwnerActionButtons(BuildContext context, ColorScheme colorScheme) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = widget.article.authorId.isNotEmpty && widget.article.authorId == currentUid;

    if (!isOwner) return [];

    return [
      CircleAvatar(
        backgroundColor: Colors.black45,
        child: IconButton(
          onPressed: () => _onEdit(context),
          icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
        ),
      ),
      const SizedBox(width: 8),
      CircleAvatar(
        backgroundColor: Colors.black45,
        child: IconButton(
          onPressed: () => _onDelete(context),
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
        ),
      ),
    ];
  }

  void _onEdit(BuildContext context) async {
    Navigator.pop(context, 'edit');
  }

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News?'),
        content: const Text('Are you sure you want to delete this article? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Trigger delete
              context.read<ProfileBloc>().add(DeleteUserNewsPost(newsId: widget.article.sourceId));
              Navigator.pop(context, 'deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
