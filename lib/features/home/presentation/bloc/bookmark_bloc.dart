import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/bookmark_use_cases.dart';
import 'package:equatable/equatable.dart';

// ── Events ───────────────────────────────────────────────────────────────────

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}

class SearchBookmarks extends BookmarkEvent {
  final String query;
  const SearchBookmarks(this.query);
  @override
  List<Object?> get props => [query];
}

class ToggleBookmark extends BookmarkEvent {
  final NewsArticle article;
  const ToggleBookmark(this.article);
  @override
  List<Object?> get props => [article];
}

class ClearBookmarks extends BookmarkEvent {}

class _OnBookmarksUpdated extends BookmarkEvent {
  final List<NewsArticle> bookmarks;
  const _OnBookmarksUpdated(this.bookmarks);
  @override
  List<Object?> get props => [bookmarks];
}

// ── State ────────────────────────────────────────────────────────────────────

class BookmarkState extends Equatable {
  final List<NewsArticle> bookmarks;
  final bool isLoading;
  final String? error;
  final String filterQuery;

  const BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.error,
    this.filterQuery = '',
  });

  List<NewsArticle> get filteredBookmarks {
    if (filterQuery.isEmpty) return bookmarks;
    final q = filterQuery.toLowerCase();
    return bookmarks.where((b) {
      return b.title.toLowerCase().contains(q) || 
             b.author.toLowerCase().contains(q) ||
             (b.content.toLowerCase().contains(q));
    }).toList();
  }

  bool isBookmarked(NewsArticle article) {
    if (article.url.isNotEmpty) {
      return bookmarks.any((b) => b.url == article.url);
    }
    return bookmarks.any((b) => b.title == article.title);
  }

  BookmarkState copyWith({
    List<NewsArticle>? bookmarks,
    bool? isLoading,
    String? Function()? error,
    String? filterQuery,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      filterQuery: filterQuery ?? this.filterQuery,
    );
  }

  @override
  List<Object?> get props => [bookmarks, isLoading, error, filterQuery];
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final AddBookmarkUseCase _addBookmark;
  final RemoveBookmarkUseCase _removeBookmark;
  final GetBookmarksStreamUseCase _getBookmarksStream;
  StreamSubscription? _bookmarksSubscription;

  BookmarkBloc({
    required AddBookmarkUseCase addBookmark,
    required RemoveBookmarkUseCase removeBookmark,
    required GetBookmarksStreamUseCase getBookmarksStream,
  })  : _addBookmark = addBookmark,
        _removeBookmark = removeBookmark,
        _getBookmarksStream = getBookmarksStream,
        super(const BookmarkState()) {
    
    on<LoadBookmarks>(_onLoadBookmarks);
    on<SearchBookmarks>(_onSearchBookmarks);
    on<ToggleBookmark>(_onToggleBookmark);
    on<ClearBookmarks>(_onClearBookmarks);
    on<_OnBookmarksUpdated>(_onBookmarksUpdated);
    
    add(LoadBookmarks());
  }

  Future<void> _onLoadBookmarks(LoadBookmarks event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      await _bookmarksSubscription?.cancel();
      _bookmarksSubscription = _getBookmarksStream().handleError((e) {
        add(_OnBookmarksUpdated(const []));
      }).listen(
        (bookmarks) => add(_OnBookmarksUpdated(bookmarks)),
        onError: (e) {
          // Stream error handled
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  void _onSearchBookmarks(SearchBookmarks event, Emitter<BookmarkState> emit) {
    emit(state.copyWith(filterQuery: event.query));
  }

  Future<void> _onToggleBookmark(ToggleBookmark event, Emitter<BookmarkState> emit) async {
    final article = event.article;
    final isCurrentlyBookmarked = state.isBookmarked(article);
    
    // --- Optimistic Update ---
    final updatedBookmarks = List<NewsArticle>.from(state.bookmarks);
    if (isCurrentlyBookmarked) {
      updatedBookmarks.removeWhere((b) => (b.url.isNotEmpty && b.url == article.url) || (b.url.isEmpty && b.title == article.title));
    } else {
      updatedBookmarks.add(article);
    }
    emit(state.copyWith(bookmarks: updatedBookmarks));

    try {
      if (isCurrentlyBookmarked) {
        await _removeBookmark(article);
      } else {
        await _addBookmark(article);
      }
    } catch (e) {
      // Revert on error
      add(LoadBookmarks()); 
      emit(state.copyWith(error: () => e.toString()));
    }
  }

  void _onBookmarksUpdated(_OnBookmarksUpdated event, Emitter<BookmarkState> emit) {
    emit(state.copyWith(
      bookmarks: event.bookmarks,
      isLoading: false,
      error: () => null,
    ));
  }

  void _onClearBookmarks(ClearBookmarks event, Emitter<BookmarkState> emit) {
    _bookmarksSubscription?.cancel();
    _bookmarksSubscription = null;
    emit(const BookmarkState());
  }

  @override
  Future<void> close() {
    _bookmarksSubscription?.cancel();
    return super.close();
  }
}
