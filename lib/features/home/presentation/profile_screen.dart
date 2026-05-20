import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_button.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_state.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/profile_news_item.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/profile_stat_item.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/profile_tab_bar.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppStrings.profile, style: AppTextStyles.headingSmall(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
          ),
        ],
      ),
      body: WebConstrainedLayout(
        scrollable: false,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Profile pic + Stats ──
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          ClipOval(
                            child: state.user.photoUrl.isNotEmpty
                                ? Image.network(
                                    state.user.photoUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 40, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    color: Theme.of(context).brightness == Brightness.dark ? colorScheme.surfaceContainer : AppColors.greyLight,
                                    child: Icon(Icons.person, size: 40, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                                  ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const ProfileStatItem(value: '0', label: AppStrings.followers),
                                    const ProfileStatItem(value: '0', label: AppStrings.following),
                                    ProfileStatItem(value: state.userNews.length.toString(), label: AppStrings.news),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Name ──
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        state.user.fullName.isNotEmpty ? state.user.fullName : state.user.username,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ── Bio ──
                    if (state.user.bio.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          state.user.bio,
                          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant, height: 1.4),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── Action buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: AppStrings.editProfile,
                            height: 46,
                            onPressed: () async {
                              await Navigator.pushNamed(context, AppRouter.editProfile, arguments: state.user);
                              if (context.mounted) context.read<ProfileBloc>().add(const LoadProfile());
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppOutlinedButton(text: AppStrings.website, height: 46, onPressed: () {}),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Tabs ──
                    ProfileTabBar(
                      tabs: const [AppStrings.news, AppStrings.recent],
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                    ),

                    const SizedBox(height: 16),

                    // ── News list ──
                    if (state.isNewsLoading)
                      const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()))
                    else if (state.userNews.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text('No news published yet.', style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.greyDark)),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.userNews.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final news = state.userNews[index];
                          return ProfileNewsItem(
                            news: news,
                            onTap: () async {
                              final article = NewsArticle(
                                sourceId: news.id,
                                authorId: news.authorId,
                                author: '',
                                title: news.title,
                                content: news.content,
                                imageUrl: news.coverImageUrl,
                                publishedAt: news.createdAt,
                                sourceName: news.authorName,
                              );
                              final result = await Navigator.pushNamed(context, AppRouter.articleDetail, arguments: article);
                              
                              if (result == 'edit' && context.mounted) {
                                final editResult = await Navigator.pushNamed(context, AppRouter.createNews, arguments: news);
                                if (editResult == true && context.mounted) context.read<ProfileBloc>().add(const LoadProfile());
                              } else if (result == 'deleted' && context.mounted) {
                                context.read<ProfileBloc>().add(const LoadProfile());
                              }
                            },
                            onEdit: () async {
                              final result = await Navigator.pushNamed(context, AppRouter.createNews, arguments: news);
                              if (result == true && context.mounted) context.read<ProfileBloc>().add(const LoadProfile());
                            },
                            onDelete: () => context.read<ProfileBloc>().add(DeleteUserNewsPost(newsId: news.id)),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
