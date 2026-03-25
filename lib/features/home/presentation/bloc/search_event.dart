import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchNews extends SearchEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {}
