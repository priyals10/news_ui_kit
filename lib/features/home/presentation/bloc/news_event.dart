import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopHeadlines extends NewsEvent {
  const FetchTopHeadlines();
}

class FetchHeadlinesByCategory extends NewsEvent {
  final String category;

  const FetchHeadlinesByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SelectArticle extends NewsEvent {
  final NewsArticle? article;
  const SelectArticle(this.article);

  @override
  List<Object?> get props => [article];
}

class ClearSelection extends NewsEvent {
  const ClearSelection();
}

class SearchHomeNews extends NewsEvent {
  final String query;
  const SearchHomeNews(this.query);
  @override
  List<Object?> get props => [query];
}
