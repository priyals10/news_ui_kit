import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_state.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';
import 'dart:io' as io;

class CreateNewsScreen extends StatefulWidget {
  final UserNewsModel? existingNews;

  const CreateNewsScreen({super.key, this.existingNews});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  XFile? _pickedImage;
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

  void _pickImage() => context.read<CreateNewsBloc>().add(const PickCoverImage());

  void _submit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter title and content.')));
      return;
    }
    if (_pickedImage == null && (_existingImageUrl == null || _existingImageUrl!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a cover photo.')));
      return;
    }

    if (widget.existingNews != null) {
      context.read<CreateNewsBloc>().add(UpdateNews(
            newsId: widget.existingNews!.id,
            title: title,
            content: content,
            createdAt: widget.existingNews!.createdAt,
            imageFile: _pickedImage,
            existingImageUrl: _existingImageUrl,
          ));
    } else {
      context.read<CreateNewsBloc>().add(PublishNews(
            title: title,
            content: content,
            imageFile: _pickedImage,
            existingImageUrl: _existingImageUrl,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CreateNewsBloc, CreateNewsState>(
      listener: (context, state) {
        if (state is CreateNewsSuccess) {
          Navigator.pop(context, true);
        } else if (state is CreateNewsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        } else if (state is CoverImagePicked) {
          setState(() => _pickedImage = state.imageFile);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateNewsLoading;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.existingNews != null ? 'Edit News' : AppStrings.createNews,
              style: AppTextStyles.headingSmall(context),
            ),
            centerTitle: true,
            actions: [
              if (widget.existingNews != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<CreateNewsBloc>().add(DeleteNews(newsId: widget.existingNews!.id));
                  },
                ),
            ],
          ),
          body: WebConstrainedLayout(
            maxWidth: 800,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surfaceContainerHighest : AppColors.greyLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
                      image: _pickedImage != null
                          ? DecorationImage(
                              image: kIsWeb 
                                  ? NetworkImage(_pickedImage!.path) 
                                  : FileImage(io.File(_pickedImage!.path)) as ImageProvider, 
                              fit: BoxFit.cover,
                            )
                          : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty
                              ? DecorationImage(image: NetworkImage(_existingImageUrl!), fit: BoxFit.cover)
                              : null),
                    ),
                    child: _pickedImage == null && (_existingImageUrl == null || _existingImageUrl!.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: colorScheme.onSurfaceVariant),
                              const SizedBox(height: 12),
                              Text('Add Cover Photo', style: AppTextStyles.bodyMedium(context)),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: AppStrings.newsTitle,
                  controller: _titleController,
                  hintText: 'Enter news title',
                ),
                const SizedBox(height: 16),
                Text(AppStrings.addNewsArticle, style: AppTextStyles.bodyLarge(context)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: TextField(
                    controller: _contentController,
                    maxLines: 15,
                    minLines: 8,
                    decoration: const InputDecoration(
                      hintText: 'Type your news content here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: WebConstrainedLayout(
            maxWidth: 800,
            scrollable: false,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.format_bold, size: 24),
                const SizedBox(width: 16),
                const Icon(Icons.format_italic, size: 24),
                const SizedBox(width: 16),
                const Icon(Icons.format_list_bulleted, size: 24),
                const Spacer(),
                AppPrimaryButton(
                  text: widget.existingNews != null ? 'Update' : AppStrings.publish,
                  fullWidth: false,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
