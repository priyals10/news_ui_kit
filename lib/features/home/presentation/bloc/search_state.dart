import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<NewsArticle> results;
  final String query;

  const SearchLoaded(this.results, this.query);

  @override
  List<Object?> get props => [results, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
