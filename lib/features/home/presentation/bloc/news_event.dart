import 'package:equatable/equatable.dart';

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

class SearchNews extends NewsEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}
