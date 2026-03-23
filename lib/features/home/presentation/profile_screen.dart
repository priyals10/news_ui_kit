import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/auth/data/user_repository.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/data/repositories/user_news_repository.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepository = UserRepository();
  final UserNewsRepository _newsRepository = UserNewsRepository();
  UserModel? _user;
  List<UserNewsModel> _userNews = [];
  bool _isLoading = true;
  bool _isLoadingNews = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    if (mounted) {
      setState(() {
        _isLoadingNews = _userNews.isEmpty; // Only show full-screen loader if list is empty
      });
    }

    // 1. Fetch User Profile Base
    try {
      final user = await _userRepository.getUserProfile(firebaseUser.uid);
      if (mounted) {
        setState(() {
          _user = user ??
              UserModel(
                uid: firebaseUser.uid,
                email: firebaseUser.email ?? '',
              );
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _user = UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
          );
          _isLoading = false;
        });
      }
    }

    // 2. Fetch User's News Separately
    try {
      final news = await _newsRepository.getUserNews(firebaseUser.uid);
      if (mounted) {
        setState(() {
          _userNews = news;
          _isLoadingNews = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _userNews = [];
          _isLoadingNews = false;
        });
      }
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
        automaticallyImplyLeading: false,
        title: Text(AppStrings.profile, style: AppTextStyles.headingSmall(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
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

                  // Profile pic (left) + Stats (right)
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.brightness == Brightness.dark ? colorScheme.surfaceContainerHighest : AppColors.greyLight,
                          backgroundImage: _user != null && _user!.photoUrl.isNotEmpty
                              ? CachedNetworkImageProvider(_user!.photoUrl)
                              : null,
                          child: _user == null || _user!.photoUrl.isEmpty
                              ? Icon(Icons.person, size: 40, color: colorScheme.onSurface.withValues(alpha: 0.7))
                              : null,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStat('2156', AppStrings.followers),
                                  _buildStat('567', AppStrings.following),
                                  _buildStat(_userNews.length.toString(), AppStrings.news),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                                    // Name
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      _user?.fullName.isNotEmpty == true
                          ? _user!.fullName
                          : (_user?.username ?? ''),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Bio
                  if (_user?.bio.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        _user!.bio,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.greyDark,
                          height: 1.4,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Buttons row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _user == null
                                ? null
                                : () async {
                                    await Navigator.pushNamed(
                                      context,
                                      AppRouter.editProfile,
                                      arguments: _user,
                                    );
                                    _loadProfile();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              AppStrings.editProfile,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              AppStrings.website,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Custom Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTab(AppStrings.news, 0),
                      _buildTab(AppStrings.recent, 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // News List
                  _isLoadingNews
                      ? const Center(child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ))
                      : _userNews.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Text(
                                  "No news published yet.",
                                  style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.greyDark),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _userNews.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final news = _userNews[index];
                                return _buildNewsItem(news, isDark: theme.brightness == Brightness.dark, colorScheme: colorScheme);
                              },
                            ),
                            
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headingSmall(context)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.greyDark),
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(UserNewsModel news, {required bool isDark, required ColorScheme colorScheme}) {
    return InkWell(
      onTap: () async {
        // Map UserNewsModel to NewsArticle domain entity for the Detail Screen
        final article = NewsArticle(
          sourceId: news.id, // Used to identify DB document for Edit/Delete
          author: '', // Leave blank to hide '· User'
          title: news.title,
          content: news.content,
          imageUrl: news.coverImageUrl,
          publishedAt: news.createdAt,
          sourceName: news.authorName, // Directly displays just the user's name
        );
        final result = await Navigator.pushNamed(context, AppRouter.articleDetail, arguments: article);
        if (result == true && mounted) {
          _loadProfile();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: news.coverImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: isDark ? colorScheme.surfaceContainerHighest : AppColors.greyLight,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'News', // Tag placeholder
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: news.authorImage.isNotEmpty
                            ? CachedNetworkImageProvider(news.authorImage)
                            : null,
                        backgroundColor: isDark ? colorScheme.surfaceContainerHighest : AppColors.greyLight,
                        child: news.authorImage.isEmpty
                            ? const Icon(Icons.person, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news.authorName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        news.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: colorScheme.onSurfaceVariant,
            onPressed: () {
              // Show bottom sheet using parent state logic
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
                          Navigator.pushNamed(context, AppRouter.createNews, arguments: news).then((result) {
                            if (result == true) _loadProfile(); // Refresh on edit
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          Navigator.pop(bottomSheetContext);
                          
                          // Optimistic UI update: remove item instantly for snappy feel
                          setState(() {
                            _userNews.removeWhere((item) => item.id == news.id);
                          });
                          
                          await _newsRepository.deleteUserNews(news.id);
                          
                          if (mounted) _loadProfile(); // Refresh from server to ensure sync
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}
