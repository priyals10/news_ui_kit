import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_button.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_state.dart';

class CreateNewsScreen extends StatefulWidget {
  final UserNewsModel? existingNews;

  const CreateNewsScreen({super.key, this.existingNews});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Local state for the picked image path (set from BLoC)
  String? _pickedImagePath;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.existingNews != null) {
      _titleController.text = widget.existingNews!.title;
      _contentController.text = widget.existingNews!.content;
      _existingImageUrl = widget.existingNews!.coverImageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // Delegate to BLoC — no ImagePicker used directly here
    context.read<CreateNewsBloc>().add(const PickCoverImage());
  }

  void _submit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and content.')),
      );
      return;
    }

    if (_pickedImagePath == null && _existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a cover photo.')),
      );
      return;
    }

    if (widget.existingNews != null) {
      context.read<CreateNewsBloc>().add(UpdateNews(
            newsId: widget.existingNews!.id,
            title: title,
            content: content,
            createdAt: widget.existingNews!.createdAt,
            imageFilePath: _pickedImagePath,
            existingImageUrl: _existingImageUrl,
          ));
    } else {
      context.read<CreateNewsBloc>().add(PublishNews(
            title: title,
            content: content,
            imageFilePath: _pickedImagePath,
            existingImageUrl: _existingImageUrl,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CreateNewsBloc, CreateNewsState>(
      listener: (context, state) {
        if (state is CreateNewsSuccess) {
          Navigator.pop(context, true);
        } else if (state is CreateNewsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        } else if (state is CoverImagePicked) {
          // Sync picked image path into local state for display
          setState(() => _pickedImagePath = state.imagePath);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateNewsLoading;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.existingNews != null ? 'Edit News' : AppStrings.createNews,
              style: AppTextStyles.headingSmall(context),
            ),
            actions: [
              if (widget.existingNews != null)
                IconButton(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  tooltip: 'Delete Post',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete News'),
                        content: const Text(
                            'Are you sure you want to delete this post?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text('Delete',
                                style:
                                    TextStyle(color: colorScheme.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      context.read<CreateNewsBloc>().add(
                            DeleteNews(newsId: widget.existingNews!.id),
                          );
                    }
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPaddingH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Cover Photo Picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: isDark
                                ? colorScheme.outline
                                : AppColors.greyLight,
                            strokeWidth: 2,
                            radius: const Radius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? colorScheme.surfaceContainerHighest
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: _pickedImagePath != null
                                  ? DecorationImage(
                                      image: FileImage(
                                          File(_pickedImagePath!)),
                                      fit: BoxFit.cover,
                                    )
                                  : (_existingImageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              _existingImageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                            ),
                            child: _pickedImagePath == null &&
                                    _existingImageUrl == null
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 32,
                                          color:
                                              colorScheme.onSurfaceVariant),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppStrings.addCoverPhoto,
                                        style: TextStyle(
                                            color: colorScheme
                                                .onSurfaceVariant),
                                      ),
                                    ],
                                  )
                                : Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white, size: 20),
                                          onPressed: _pickImage,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title Field
                      TextField(
                        controller: _titleController,
                        style: AppTextStyles.headingSmall(context).copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.newsTitle,
                          hintStyle:
                              AppTextStyles.headingSmall(context).copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.normal,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: isDark
                                    ? colorScheme.outline
                                    : AppColors.greyLight),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: isDark
                                    ? colorScheme.outline
                                    : AppColors.greyLight),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: colorScheme.primary),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Content Field
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        minLines: 8,
                        style: AppTextStyles.bodyMedium(context)
                            .copyWith(height: 1.5),
                        decoration: InputDecoration(
                          hintText: AppStrings.addNewsArticle,
                          hintStyle:
                              AppTextStyles.bodyMedium(context).copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),

          // Bottom Toolbar
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                      color: isDark
                          ? colorScheme.outline
                          : AppColors.greyLight),
                ),
              ),
              child: Row(
                children: [
                  _ToolIcon(
                      icon: Icons.format_bold, colorScheme: colorScheme),
                  _ToolIcon(
                      icon: Icons.format_italic, colorScheme: colorScheme),
                  _ToolIcon(
                      icon: Icons.format_list_bulleted,
                      colorScheme: colorScheme),
                  _ToolIcon(
                      icon: Icons.format_list_numbered,
                      colorScheme: colorScheme),
                  _ToolIcon(icon: Icons.link, colorScheme: colorScheme),
                  const Spacer(),
                  // Use AppButton — no inline styleFrom()
                  AppButton(
                    text: widget.existingNews != null
                        ? 'Update'
                        : AppStrings.publish,
                    isLoading: isLoading,
                    fullWidth: false,
                    horizontalPadding: 24,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Private helper widget for toolbar icons ──────────────────────────────────

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({required this.icon, required this.colorScheme});

  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
    );
  }
}

// ── DashedBorderPainter ──────────────────────────────────────────────────────

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Radius radius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final Path path = Path()..addRRect(rrect);

    const double dashWidth = 6.0;
    const double dashSpace = 4.0;
    for (PathMetric measurePath in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        final Path extractPath =
            measurePath.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
