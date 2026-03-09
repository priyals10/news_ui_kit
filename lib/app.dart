import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/theme/app_theme.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/home/data/data_sources/news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/data/repositories/news_repository_impl.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_top_headlines_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_headlines_by_category_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/search_articles_use_case.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/news_bloc.dart';
import 'package:news_ui_kit/core/theme/theme_mode_notifier.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Wire up: DataSource → Repository → UseCases → BLoC
    final dataSource = NewsRemoteDataSource();
    final repository = NewsRepositoryImpl(dataSource);
    final getTopHeadlines = GetTopHeadlinesUseCase(repository);
    final getHeadlinesByCategory = GetHeadlinesByCategoryUseCase(repository);
    final searchArticles = SearchArticlesUseCase(repository);

    // Use ValueListenableBuilder to listen to theme changes
    return BlocProvider(
      create: (_) => NewsBloc(getTopHeadlines, getHeadlinesByCategory, searchArticles),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.splash,
          );
        },
      ),
    );
  }
}
