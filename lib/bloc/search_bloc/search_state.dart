part of 'search_bloc.dart';

enum SearchStatus { initial, submitted, loading, success, update, failure }

enum SearchSortedBy { standart, stargazers, watchers }

class SearchState extends Equatable {
  final SearchStatus status;
  final bool isNextPageEmpty;
  final int page;
  final SearchSortedBy sortedBy;
  final int entriesCount;
  final String query;
  final List<GitRepository> repositories;
  final String error;
  const SearchState({
    this.isNextPageEmpty = true,
    this.page = 1,
    this.entriesCount = 10,
    this.sortedBy = SearchSortedBy.standart,
    this.status = SearchStatus.initial,
    this.query = '',
    this.repositories = const [],
    this.error = '',
  });

  SearchState copyWith({
    bool? isNextPageEmpty,
    int? entriesCount,
    SearchSortedBy? sortedBy,
    SearchStatus? status,
    int? page,
    String? query,
    List<GitRepository>? repositories,
    String? error,
    bool? isInputTextCorrect,
  }) {
    return SearchState(
      isNextPageEmpty: isNextPageEmpty ?? this.isNextPageEmpty,
      page: page ?? this.page,
      entriesCount: entriesCount ?? this.entriesCount,
      sortedBy: sortedBy ?? this.sortedBy,
      status: status ?? this.status,
      query: query ?? this.query,
      repositories: repositories ?? this.repositories,
      error: error ?? this.error,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        page,
        entriesCount,
        status,
        query,
        repositories,
        error,
        sortedBy,
      ];
}
