part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class SearchSubmittedEvent extends SearchEvent {
  SearchSubmittedEvent(this.query);
  final String query;
  @override
  List<Object> get props => [query];
}

class SearchUpdateEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SearchSortedEvent extends SearchEvent {
  SearchSortedEvent(this.sortedBy);
  final SearchSortedBy sortedBy;

  @override
  List<Object> get props => [sortedBy];
}

class SearchEntriesCountChangedEvent extends SearchEvent {
  final int entriesCount;
  SearchEntriesCountChangedEvent(this.entriesCount);

  @override
  List<Object> get props => [entriesCount];
}

class SearchPageChangedEvent extends SearchEvent {
  final int page;
  SearchPageChangedEvent(this.page);

  @override
  List<Object> get props => [page];
}
