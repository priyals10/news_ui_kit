import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final List<NewsArticle> latestArticles;
  final String selectedCategory;
  final bool isLatestLoading;
  final NewsArticle? selectedArticle;
  final String searchQuery;

  const NewsLoaded(
    this.articles, {
    this.latestArticles = const [],
    this.selectedCategory = 'All',
    this.isLatestLoading = false,
    this.selectedArticle,
    this.searchQuery = '',
  });

  List<NewsArticle> get allSearchResults {
    if (searchQuery.isEmpty) return [];
    final q = searchQuery.toLowerCase();
    final results = <NewsArticle>[];
    final urls = <String>{};
    for (var a in [...articles, ...latestArticles]) {
      if (a.title.toLowerCase().contains(q) || a.content.toLowerCase().contains(q)) {
        if (a.url.isNotEmpty && !urls.contains(a.url)) {
           urls.add(a.url);
           results.add(a);
        } else if (a.url.isEmpty) {
           results.add(a);
        }
      }
    }
    return results;
  }

  NewsLoaded copyWith({
    List<NewsArticle>? articles,
    List<NewsArticle>? latestArticles,
    String? selectedCategory,
    bool? isLatestLoading,
    NewsArticle? selectedArticle,
    String? searchQuery,
    bool clearSelection = false,
  }) {
    return NewsLoaded(
      articles ?? this.articles,
      latestArticles: latestArticles ?? this.latestArticles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLatestLoading: isLatestLoading ?? this.isLatestLoading,
      selectedArticle: clearSelection ? null : (selectedArticle ?? this.selectedArticle),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [articles, latestArticles, selectedCategory, isLatestLoading, selectedArticle, searchQuery];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
