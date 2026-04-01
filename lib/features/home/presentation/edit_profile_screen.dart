import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/utils/media_picker_helper.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  File? _newProfileImage;

  String? usernameError;
  String? fullNameError;
  String? emailError;
  String? phoneError;

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

  Future<void> _pickImage({required bool isCamera}) async {
    final file = isCamera
        ? await MediaPickerHelper.pickFromCamera(imageQuality: 70)
        : await MediaPickerHelper.pickFromGallery(imageQuality: 70);
    if (file != null) {
      setState(() => _newProfileImage = file);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXXL)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(AppStrings.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(isCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text(AppStrings.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(isCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      usernameError = _usernameController.text.trim().isEmpty
          ? AppStrings.usernameRequired
          : null;
      fullNameError = _fullNameController.text.trim().isEmpty
          ? 'Full name is required'
          : null;
      emailError = _emailController.text.trim().isEmpty
          ? AppStrings.emailRequired
          : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(_emailController.text.trim())
              ? AppStrings.invalidEmail
              : null;
      phoneError = _phoneController.text.trim().isEmpty
          ? AppStrings.phoneRequired
          : !RegExp(r'^[0-9]{10,13}$').hasMatch(_phoneController.text.trim())
              ? AppStrings.invalidPhone
              : null;

      if (usernameError != null ||
          fullNameError != null ||
          emailError != null ||
          phoneError != null) {
        isValid = false;
      }
    });
    return isValid;
  }

  void _saveProfile() {
    if (!_validate()) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    context.read<ProfileBloc>().add(
          UpdateProfile(
            uid: firebaseUser.uid,
            currentUser: widget.user,
            newProfileImagePath: _newProfileImage?.path,
            updatedFields: {
              'uid': firebaseUser.uid,
              'username': _usernameController.text.trim(),
              'fullName': _fullNameController.text.trim(),
              'email': _emailController.text.trim(),
              'phone': _phoneController.text.trim(),
              'bio': _bioController.text.trim(),
              'website': _websiteController.text.trim(),
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final isSaving = state is ProfileUpdating;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                AppStrings.editProfile,
                style: AppTextStyles.headingSmall(context),
              ),
              actions: [
                isSaving
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
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    AppSizes.spacingXL,
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
                                      ? CachedNetworkImageProvider(
                                          widget.user.photoUrl)
                                      : null)
                                  as ImageProvider?,
                          child: _newProfileImage == null &&
                                  widget.user.photoUrl.isEmpty
                              ? const Icon(Icons.person,
                                  size: 50, color: AppColors.greyDark)
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
                              child: const Icon(Icons.camera_alt,
                                  size: 18, color: AppColors.white),
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
                    errorText: usernameError,
                    isRequired: false,
                  ),
                  AuthTextField(
                    label: AppStrings.fullName,
                    controller: _fullNameController,
                    errorText: fullNameError,
                    isRequired: false,
                  ),
                  AuthTextField(
                    label: AppStrings.emailAddress,
                    controller: _emailController,
                    errorText: emailError,
                  ),
                  AuthTextField(
                    label: AppStrings.phoneNumber,
                    controller: _phoneController,
                    errorText: phoneError,
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
        },
      ),
    );
  }
}


