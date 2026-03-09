import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/auth/data/user_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _websiteController;

  final UserRepository _userRepository = UserRepository();
  final ImagePicker _picker = ImagePicker();
  File? _newProfileImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.bio);
    _websiteController = TextEditingController(text: widget.user.website);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXXL)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppStrings.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text(AppStrings.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return;

      String photoUrl = widget.user.photoUrl;

      if (_newProfileImage != null) {
        photoUrl = await _userRepository.uploadProfileImage(
          uid: firebaseUser.uid,
          imageFile: _newProfileImage!,
        );
      }

      await _userRepository.saveOrUpdateProfile(firebaseUser.uid, {
        'uid': firebaseUser.uid,
        'username': _usernameController.text.trim(),
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'website': _websiteController.text.trim(),
        'photoUrl': photoUrl,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.editProfile, style: AppTextStyles.headingSmall(context)),
        centerTitle: true,
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check, color: AppColors.primary),
                  onPressed: _saveProfile,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSizes.screenPaddingH,
          right: AppSizes.screenPaddingH,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingXL,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingXL),

            // Profile photo with camera overlay
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: AppSizes.avatarRadius,
                    backgroundColor: AppColors.greyLight,
                    backgroundImage: _newProfileImage != null
                        ? FileImage(_newProfileImage!)
                        : (widget.user.photoUrl.isNotEmpty
                                ? CachedNetworkImageProvider(widget.user.photoUrl)
                                : null)
                            as ImageProvider?,
                    child: _newProfileImage == null && widget.user.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 50, color: AppColors.greyDark)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 18, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingXXL),

            AuthTextField(
              label: AppStrings.username,
              controller: _usernameController,
              isRequired: false,
            ),

            AuthTextField(
              label: AppStrings.fullName,
              controller: _fullNameController,
              isRequired: false,
            ),

            AuthTextField(
              label: AppStrings.emailAddress,
              controller: _emailController,
            ),

            AuthTextField(
              label: AppStrings.phoneNumber,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),

            AuthTextField(
              label: AppStrings.bio,
              controller: _bioController,
              isRequired: false,
            ),

            AuthTextField(
              label: AppStrings.website,
              controller: _websiteController,
              isRequired: false,
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: AppSizes.spacingXL),
          ],
        ),
      ),
    );
  }
}
