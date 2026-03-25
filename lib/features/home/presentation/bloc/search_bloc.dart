import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/search_articles_use_case.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticlesUseCase _searchArticles;

  SearchBloc(this._searchArticles) : super(SearchInitial()) {
    on<SearchNews>(_onSearchNews);
    on<ClearSearch>(_onClearSearch);
  }

  /// Strips the "Exception: " prefix from error messages for clean UI display.
  String _cleanErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await _searchArticles(query: event.query);
      emit(SearchLoaded(results, event.query));
    } catch (e) {
      emit(SearchError(_cleanErrorMessage(e)));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
