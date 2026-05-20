import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:news_ui_kit/core/theme/app_theme.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/home/data/data_sources/news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/data/repositories/news_repository_impl.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_top_headlines_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_headlines_by_category_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/search_articles_use_case.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/search_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/profile_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/create_news_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/features/home/data/repositories/bookmark_repository.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/data/repositories/auth_repository_impl.dart' as data_auth;
import 'package:news_ui_kit/features/home/data/repositories/user_news_repository_impl.dart' as data_news;
import 'package:news_ui_kit/features/auth/data/repositories/user_repository_impl.dart' as data_user;
import 'package:news_ui_kit/features/home/domain/use_cases/bookmark_use_cases.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/user_use_cases.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/user_news_use_cases.dart' as domain_news;
import 'package:isar/isar.dart';
import 'package:news_ui_kit/core/network_info.dart';
import 'package:news_ui_kit/features/home/data/data_sources/user_news_local_data_source.dart';
import 'package:news_ui_kit/features/home/data/data_sources/user_news_remote_data_source.dart';


import 'package:news_ui_kit/core/theme/theme_mode_notifier.dart';

class App extends StatelessWidget {
  final Isar? isar;
  const App({super.key, this.isar});

  @override
  Widget build(BuildContext context) {
    // Wire up: DataSource → Repository → UseCases → BLoC
    final isar = this.isar;
    
    if (isar == null && !kIsWeb) {
      debugPrint("Warning: Database instance is null. Offline mode will be disabled.");
    }

    final networkInfo = NetworkInfo();
    final dataSource = NewsRemoteDataSource();
    
    // We pass isar (which might be null on Web)
    final repository = NewsRepositoryImpl(dataSource, isar, networkInfo);
    final getTopHeadlines = GetTopHeadlinesUseCase(repository);
    final getHeadlinesByCategory = GetHeadlinesByCategoryUseCase(repository);
    final searchArticles = SearchArticlesUseCase(repository);

    final bookmarkRepo = BookmarkRepository();
    final addBookmark = AddBookmarkUseCase(bookmarkRepo);
    final removeBookmark = RemoveBookmarkUseCase(bookmarkRepo);
    final getBookmarksStream = GetBookmarksStreamUseCase(bookmarkRepo);

    final userRepo = data_user.UserRepositoryImpl();
    final getUserProfile = GetUserProfileUseCase(userRepo);
    final uploadImage = UploadProfileImageUseCase(userRepo);
    final saveOrUpdateProfile = SaveOrUpdateProfileUseCase(userRepo);

    // Offline-First Setup
    final userNewsLocal = UserNewsLocalDataSource(isar);
    final userNewsRemote = UserNewsRemoteDataSource();

    final userNewsRepo = data_news.UserNewsRepositoryImpl(
      localDataSource: userNewsLocal,
      remoteDataSource: userNewsRemote,
      networkInfo: networkInfo,
    );
    final getUserNews = domain_news.GetUserNewsUseCase(userNewsRepo);
    final deleteUserNews = domain_news.DeleteUserNewsUseCase(userNewsRepo);
    final createUserNews = domain_news.CreateUserNewsUseCase(userNewsRepo);
    final updateUserNews = domain_news.UpdateUserNewsUseCase(userNewsRepo);

    final authRepo = data_auth.AuthRepositoryImpl();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NewsBloc(getTopHeadlines, getHeadlinesByCategory),
        ),
        BlocProvider(
          create: (_) => SearchBloc(searchArticles),
        ),
        // ProfileBloc is lazy — created when the Profile screen is first shown.
        BlocProvider(
          create: (_) => ProfileBloc(
            getUserProfile: getUserProfile,
            saveOrUpdateProfile: saveOrUpdateProfile,
            uploadProfileImage: uploadImage,
            getUserNews: getUserNews,
            deleteUserNews: deleteUserNews,
          ),
        ),
        // CreateNewsBloc is lazy — created when the CreateNews screen opens.
        BlocProvider(
          create: (_) => CreateNewsBloc(
            getUserProfile: getUserProfile,
            createUserNews: createUserNews,
            updateUserNews: updateUserNews,
            deleteUserNews: deleteUserNews,
          ),
        ),
        BlocProvider(
          create: (_) => BookmarkBloc(
            addBookmark: addBookmark,
            removeBookmark: removeBookmark,
            getBookmarksStream: getBookmarksStream,
          ),
        ),
        BlocProvider(
          create: (_) => AuthBloc(authRepo, userRepo),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp(
            title: 'Kabar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.splash,
            builder: (context, child) {
              return Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  final isDark = theme.brightness == Brightness.dark;
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: (isDark
                            ? AppTheme.darkSystemUI
                            : AppTheme.defaultSystemUI)
                        .copyWith(
                      systemNavigationBarColor: theme.colorScheme.surface,
                    ),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
