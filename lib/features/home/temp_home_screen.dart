import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/auth/data/user_repository.dart';

class TempHomeScreen extends StatefulWidget {
  const TempHomeScreen({super.key});

  @override
  State<TempHomeScreen> createState() => _TempHomeScreenState();
}

class _TempHomeScreenState extends State<TempHomeScreen> {
  final UserRepository _userRepository = UserRepository();
  UserModel? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _userRepository.getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email';
    final displayName = _userProfile?.fullName.isNotEmpty == true
        ? _userProfile!.fullName
        : email;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.spacingHuge),

                    // ── Avatar ──
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      backgroundImage: _userProfile?.photoUrl.isNotEmpty == true
                          ? NetworkImage(_userProfile!.photoUrl)
                          : null,
                      child: _userProfile?.photoUrl.isNotEmpty == true
                          ? null
                          : Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),

                    const SizedBox(height: AppSizes.spacingMD),

                    // ── Welcome text ──
                    Text(
                      'Welcome${_userProfile?.fullName.isNotEmpty == true ? ', ${_userProfile!.fullName}' : ''}!',
                      style: AppTextStyles.headingMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingSM),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: AppColors.greyDark),
                    ),

                    if (_userProfile?.country.isNotEmpty == true) ...[
                      const SizedBox(height: AppSizes.spacingXS),
                      Text(
                        _userProfile!.country,
                        style: const TextStyle(fontSize: 14, color: AppColors.greyDark),
                      ),
                    ],

                    const SizedBox(height: AppSizes.spacingHuge),

                    const Spacer(),

                    // ── Logout button ──
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await AuthRepository().signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRouter.onboarding,
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: AppColors.error),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: AppColors.error, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingXL),
                  ],
                ),
              ),
      ),
    );
  }
}
