import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/services/cloudinary_service.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/auth/data/user_repository.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/data/repositories/user_news_repository.dart';

class CreateNewsScreen extends StatefulWidget {
  final UserNewsModel? existingNews;

  const CreateNewsScreen({super.key, this.existingNews});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final UserNewsRepository _newsRepository = UserNewsRepository();
  final UserRepository _userRepository = UserRepository();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _existingImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingNews != null) {
      _titleController.text = widget.existingNews!.title;
      _contentController.text = widget.existingNews!.content;
      _existingImageUrl = widget.existingNews!.coverImageUrl;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _publishNews() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and content.')),
      );
      return;
    }

    if (_imageFile == null && _existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a cover photo.')),
      );
      return;
    }

    final currUser = FirebaseAuth.instance.currentUser;
    if (currUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get author details
      final userProfile = await _userRepository.getUserProfile(currUser.uid);
      String authorName = userProfile?.fullName ?? userProfile?.username ?? 'Anonymous';
      String authorImage = userProfile?.photoUrl ?? '';

      // Upload image to Cloudinary ONLY if a new file is picked
      String? uploadedImageUrl = _existingImageUrl;
      if (_imageFile != null) {
        uploadedImageUrl = await CloudinaryService.uploadImage(XFile(_imageFile!.path));
        if (uploadedImageUrl == null) {
          throw Exception("Failed to upload new image. Make sure Cloudinary is correctly configured.");
        }
      }

      // 3. Save to Firestore
      final isEditing = widget.existingNews != null;
      final newId = isEditing ? widget.existingNews!.id : DateTime.now().millisecondsSinceEpoch.toString();
      
      final userNews = UserNewsModel(
        id: newId,
        authorId: currUser.uid,
        authorName: authorName,
        authorImage: authorImage,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        coverImageUrl: uploadedImageUrl ?? '',
        createdAt: isEditing ? widget.existingNews!.createdAt : DateTime.now(),
      );

      if (isEditing) {
        await _newsRepository.updateUserNews(userNews);
      } else {
        await _newsRepository.createUserNews(userNews);
      }

      if (mounted) {
        Navigator.pop(context, true); // true to indicate success and need to refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.existingNews != null ? 'Edit News' : AppStrings.createNews, style: AppTextStyles.headingSmall(context)),
        centerTitle: true,
        actions: [
          if (widget.existingNews != null)
            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              tooltip: 'Delete Post',
              onPressed: () async {
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
                  setState(() => _isLoading = true);
                  await _newsRepository.deleteUserNews(widget.existingNews!.id);
                  if (context.mounted) {
                    Navigator.pop(context, true); // true to signal refresh
                  }
                }
              },
            )
          else
            IconButton(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onPressed: () {},
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  
                  // Cover Photo Picker Area
                  GestureDetector(
                    onTap: _pickImage,
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: isDark ? colorScheme.outline : AppColors.greyLight,
                        strokeWidth: 2,
                        radius: const Radius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surfaceContainerHighest : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                )
                              : (_existingImageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_existingImageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: _imageFile == null && _existingImageUrl == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 32, color: colorScheme.onSurfaceVariant),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.addCoverPhoto,
                                    style: TextStyle(color: colorScheme.onSurfaceVariant),
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
                                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // News Title Field
                  TextField(
                    controller: _titleController,
                    style: AppTextStyles.headingSmall(context).copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.newsTitle,
                      hintStyle: AppTextStyles.headingSmall(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.normal,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDark ? colorScheme.outline : AppColors.greyLight),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDark ? colorScheme.outline : AppColors.greyLight),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // News Article Body
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 8,
                    style: AppTextStyles.bodyMedium(context).copyWith(height: 1.5),
                    decoration: InputDecoration(
                      hintText: AppStrings.addNewsArticle,
                      hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 80), // Space for bottom toolbar
                ],
              ),
            ),
            
      // Bottom Toolbar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: isDark ? colorScheme.outline : AppColors.greyLight),
            ),
          ),
          child: Row(
            children: [
              // Dummy styling icons
              _buildToolIcon(Icons.format_bold, colorScheme),
              _buildToolIcon(Icons.format_italic, colorScheme),
              _buildToolIcon(Icons.format_list_bulleted, colorScheme),
              _buildToolIcon(Icons.format_list_numbered, colorScheme),
              _buildToolIcon(Icons.link, colorScheme),
              
              const Spacer(),
              
              // Publish Button
              ElevatedButton(
                onPressed: _isLoading ? null : _publishNews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.existingNews != null ? 'Update' : AppStrings.publish,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Icon(
        icon,
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

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
        final Path extractPath = measurePath.extractPath(distance, distance + dashWidth);
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
