import 'package:news_ui_kit/core/utils/preferences_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_state.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  XFile? _profileImage;

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
        _profileImage = pickedFile;
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
            newProfileImage: _profileImage,
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
            PreferencesHelper.setHasCompletedSetup(true);
            Navigator.pushReplacementNamed(context, AppRouter.welcome);
          } else if (state is ProfileError) {
             _showErrorWithFallback(state.message);
          }
        },
        child: SafeArea(
          child: WebConstrainedLayout(
            maxWidth: 500,
            scrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.spacingXL),
  
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    Text(
                      AppStrings.fillYourProfile, 
                      style: AppTextStyles.headingSmall(context).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
  
                const SizedBox(height: 32),
  
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: kIsWeb 
                                    ? NetworkImage(_profileImage!.path) as ImageProvider
                                    : FileImage(File(_profileImage!.path)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onSurfaceVariant)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageSourceSheet,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 16, color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
  
                const SizedBox(height: 32),
  
                _buildCompactField(
                  label: AppStrings.username,
                  controller: usernameController,
                  hint: "Enter your username",
                ),
  
                _buildCompactField(
                  label: AppStrings.fullName,
                  controller: fullNameController,
                  hint: "Enter your full name",
                ),
  
                _buildCompactField(
                  label: AppStrings.emailAddress,
                  controller: emailController,
                  hint: "Enter your email",
                  error: emailError,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),
  
                _buildCompactField(
                  label: AppStrings.phoneNumber,
                  controller: phoneController,
                  hint: "Enter your phone number",
                  error: phoneError,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                ),
  
                const SizedBox(height: 32),
  
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading || state is ProfileUpdating;
                    return AppPrimaryButton(
                      text: AppStrings.next,
                      isLoading: isLoading,
                      onPressed: _validateAndSubmit,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.spacingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? error,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label, 
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              const Text(" *", style: TextStyle(color: Colors.red, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        AppTextField(
          label: "", // Using custom label above
          controller: controller,
          isRequired: false,
          hintText: hint,
          errorText: error,
          keyboardType: keyboardType,
        ),
        // Adjustment to remove extra space from AppTextField's internal label logic
      ],
    );
  }

  void _showErrorWithFallback(String message) {
    final bool isTimeout = message.toLowerCase().contains("timeout") || message.toLowerCase().contains("check your internet");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connection Issue"),
        content: Text(isTimeout 
          ? "The photo upload is taking too long. Would you like to skip the photo for now and finish your profile?"
          : message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Retry"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitWithoutImage();
            },
            child: const Text("Skip Photo"),
          ),
        ],
      ),
    );
  }

  void _submitWithoutImage() {
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
      photoUrl: '',
    );

    context.read<ProfileBloc>().add(UpdateProfile(
          uid: firebaseUser.uid,
          currentUser: userModel,
          updatedFields: userModel.toMap(),
          newProfileImage: null,
        ));
  }
}
