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

  const NewsLoaded(
    this.articles, {
    this.latestArticles = const [],
    this.selectedCategory = 'All',
    this.isLatestLoading = false,
  });

  NewsLoaded copyWith({
    List<NewsArticle>? articles,
    List<NewsArticle>? latestArticles,
    String? selectedCategory,
    bool? isLatestLoading,
  }) {
    return NewsLoaded(
      articles ?? this.articles,
      latestArticles: latestArticles ?? this.latestArticles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLatestLoading: isLatestLoading ?? this.isLatestLoading,
    );
  }

  @override
  List<Object?> get props => [articles, latestArticles, selectedCategory, isLatestLoading];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
