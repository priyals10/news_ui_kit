import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_top_headlines_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_headlines_by_category_use_case.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlinesUseCase _getTopHeadlines;
  final GetHeadlinesByCategoryUseCase _getHeadlinesByCategory;

  final Map<String, List<NewsArticle>> _categoryCache = {};

  NewsBloc(this._getTopHeadlines, this._getHeadlinesByCategory)
      : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<FetchHeadlinesByCategory>(_onFetchHeadlinesByCategory);
  }

  /// Strips the "Exception: " prefix from error messages for clean UI display.
  String _cleanErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      _categoryCache.clear();
      await emit.forEach<List<NewsArticle>>(
        _getTopHeadlines(),
        onData: (articles) {
          // Pulse 1 or 2: Articles are returned
          return NewsLoaded(articles);
        },
        onError: (e, _) => NewsError(_cleanErrorMessage(e)),
      );

      // Auto-fetch latest (All) after trending loads
      add(const FetchHeadlinesByCategory('All'));
    } catch (e) {
      emit(NewsError(_cleanErrorMessage(e)));
    }
  }

  Future<void> _onFetchHeadlinesByCategory(
    FetchHeadlinesByCategory event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;

    // Load from memory cache instantly if available (Very rare now with Isar, but good to keep)
    if (_categoryCache.containsKey(event.category) && currentState is NewsLoaded) {
      emit(currentState.copyWith(
        latestArticles: _categoryCache[event.category],
        selectedCategory: event.category,
        isLatestLoading: false,
      ));
    }

    // Prepare UI state
    if (currentState is NewsLoaded) {
      emit(currentState.copyWith(
        isLatestLoading: true,
        selectedCategory: event.category,
      ));
    }

    try {
      // Map display names to NewsAPI category values
      String? apiCategory;
      switch (event.category) {
        case 'All':
          apiCategory = null;
          break;
        case 'Politics':
          apiCategory = 'general';
          break;
        case 'Travel':
          apiCategory = 'entertainment';
          break;
        default:
          apiCategory = event.category.toLowerCase();
      }

      final stream = apiCategory == null
          ? _getTopHeadlines()
          : _getHeadlinesByCategory(category: apiCategory);

      await emit.forEach<List<NewsArticle>>(
        stream,
        onData: (latestArticles) {
          _categoryCache[event.category] = latestArticles;
          final current = state;
          if (current is NewsLoaded) {
            return current.copyWith(
              latestArticles: latestArticles,
              selectedCategory: event.category,
              isLatestLoading: false,
            );
          }
          return NewsLoaded(latestArticles, selectedCategory: event.category);
        },
        onError: (e, _) => state is NewsLoaded ? (state as NewsLoaded).copyWith(isLatestLoading: false) : NewsError(_cleanErrorMessage(e)),
      );
    } catch (e) {
      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(
          isLatestLoading: false,
          selectedCategory: event.category,
        ));
      }
    }
  }
}
