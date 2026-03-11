import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_top_headlines_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/get_headlines_by_category_use_case.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/search_articles_use_case.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlinesUseCase _getTopHeadlines;
  final GetHeadlinesByCategoryUseCase _getHeadlinesByCategory;
  final SearchArticlesUseCase _searchArticles;

  final Map<String, List<NewsArticle>> _categoryCache = {};

  NewsBloc(this._getTopHeadlines, this._getHeadlinesByCategory, this._searchArticles)
      : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<FetchHeadlinesByCategory>(_onFetchHeadlinesByCategory);
    on<SearchNews>(_onSearchNews);
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
      final articles = await _getTopHeadlines();
      emit(NewsLoaded(articles));
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
    
    // Load from cache instantly if available to prevent redundant API calls
    if (_categoryCache.containsKey(event.category)) {
      if (currentState is NewsLoaded) {
        emit(currentState.copyWith(
          latestArticles: _categoryCache[event.category],
          selectedCategory: event.category,
          isLatestLoading: false,
        ));
      }
      return;
    }

    // Keep trending articles while loading latest
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

      final latestArticles = apiCategory == null
          ? await _getTopHeadlines()
          : await _getHeadlinesByCategory(category: apiCategory);
          
      _categoryCache[event.category] = latestArticles;

      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(
          latestArticles: latestArticles,
          selectedCategory: event.category,
          isLatestLoading: false,
        ));
      }
    } catch (e) {
      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(
          isLatestLoading: false,
          selectedCategory: event.category,
        ));
      }
    }
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final results = await _searchArticles(query: event.query);
      emit(SearchLoaded(results, event.query));
    } catch (e) {
      emit(SearchError(_cleanErrorMessage(e)));
    }
  }
}
