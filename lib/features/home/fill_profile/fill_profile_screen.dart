import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_state.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  String? emailError;
  String? phoneError;

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
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

  void _validateAndSubmit() {
    setState(() {
      if (emailController.text.isEmpty) {
        emailError = AppStrings.emailRequired;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(emailController.text)) {
        emailError = AppStrings.invalidEmail;
      } else {
        emailError = null;
      }

      if (phoneController.text.isEmpty) {
        phoneError = AppStrings.phoneRequired;
      } else if (!RegExp(r'^[0-9]{10,13}$').hasMatch(phoneController.text)) {
        phoneError = AppStrings.invalidPhone;
      } else {
        phoneError = null;
      }
    });

    if (emailError == null && phoneError == null) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return;

      final country = ModalRoute.of(context)?.settings.arguments as String? ?? '';

      final userModel = UserModel(
        uid: firebaseUser.uid,
        username: usernameController.text.trim(),
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        country: country,
        photoUrl: '', // Will be updated by BLoC
      );

      context.read<ProfileBloc>().add(UpdateProfile(
            uid: firebaseUser.uid,
            currentUser: userModel,
            updatedFields: userModel.toMap(),
            newProfileImagePath: _profileImage?.path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSizes.screenPaddingH,
              right: AppSizes.screenPaddingH,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.spacingXL),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(AppStrings.fillYourProfile, style: AppTextStyles.headingSmall(context)),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),

                const SizedBox(height: AppSizes.spacingXXL),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.avatarRadius,
                        backgroundColor: AppColors.greyLight,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
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
                  controller: usernameController,
                  isRequired: false,
                ),

                AuthTextField(
                  label: AppStrings.fullName,
                  controller: fullNameController,
                  isRequired: false,
                ),

                AuthTextField(
                  label: AppStrings.emailAddress,
                  controller: emailController,
                  errorText: emailError,
                  keyboardType: TextInputType.emailAddress,
                ),

                AuthTextField(
                  label: AppStrings.phoneNumber,
                  controller: phoneController,
                  errorText: phoneError,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: AppSizes.spacingXXL),

                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _validateAndSubmit,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text(AppStrings.next),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
