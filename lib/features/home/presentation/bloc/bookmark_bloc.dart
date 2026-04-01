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

  const BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.error,
  });

  bool isBookmarked(NewsArticle article) {
    return bookmarks.any((b) => b.url == article.url);
  }

  BookmarkState copyWith({
    List<NewsArticle>? bookmarks,
    bool? isLoading,
    String? Function()? error, // Function pattern to allow passing null explicitly
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [bookmarks, isLoading, error];
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
    on<ToggleBookmark>(_onToggleBookmark);
    on<ClearBookmarks>(_onClearBookmarks);
    on<_OnBookmarksUpdated>(_onBookmarksUpdated);
    
    // Auto-start listening on creation. It will pick up UID if already logged in.
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
          // You could add a specific event for stream error if needed
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> _onToggleBookmark(ToggleBookmark event, Emitter<BookmarkState> emit) async {
    final isCurrentlyBookmarked = state.isBookmarked(event.article);
    try {
      if (isCurrentlyBookmarked) {
        await _removeBookmark(event.article);
      } else {
        await _addBookmark(event.article);
      }
    } catch (e) {
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
