import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:search_user_repository/search_user_repository.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchUserRepository searchUserRepository})
      : _searchUserRepository = searchUserRepository,
        super(const SearchState()) {
    on<SearchSortedEvent>(_onSearchSortedEvent);
    on<SearchSubmittedEvent>(_onSearchSubmittedEvent);
    on<SearchEntriesCountChangedEvent>(_onSearchEntriesCountChangedEvent);
    on<SearchPageChangedEvent>(_onSearchPageChangedEvent);
    on<SearchUpdateEvent>(_onSearchUpdateEvent);
  }

  late final SearchUserRepository _searchUserRepository;
  final List<GitRepository> repos = [];
  bool isNextPageEmpty = true;

  Future<void> _getRepositoriesAndNextPageFromApi(
      {required String query}) async {
    repos.clear();
    repos.addAll(await _searchUserRepository.onSearchToModel(
        query: query, perPage: state.entriesCount, page: state.page));
    isNextPageEmpty = await _searchUserRepository.isSearchNextPageEmpty(
        query: query, page: state.page);
  }

  void _sortListRepositories(SearchSortedBy sortedBy) {
    if (sortedBy == SearchSortedBy.stargazers) {
      repos.sort(
        (a, b) => int.parse(b.watchers!).compareTo(int.parse(a.watchers!)),
      );
    } else if (sortedBy == SearchSortedBy.watchers) {
      repos.sort(
        (a, b) => int.parse(b.watchers!).compareTo(int.parse(a.watchers!)),
      );
    } else {
      return;
    }
  }

  Future<void> _onSearchUpdateEvent(
      SearchUpdateEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      await _getRepositoriesAndNextPageFromApi(query: state.query);
      _sortListRepositories(state.sortedBy);
      emit(state.copyWith(
        status: SearchStatus.update,
        repositories: repos,
        isNextPageEmpty: isNextPageEmpty,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSearchSubmittedEvent(
    SearchSubmittedEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.submitted));

    try {
      emit(state.copyWith(status: SearchStatus.loading));
      await _getRepositoriesAndNextPageFromApi(query: event.query);

      emit(state.copyWith(
        query: event.query,
        status: SearchStatus.success,
        sortedBy: state.sortedBy,
        repositories: repos,
        isNextPageEmpty: isNextPageEmpty,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  void _onSearchSortedEvent(
    SearchSortedEvent event,
    Emitter<SearchState> emit,
  ) {
    if (event.sortedBy == SearchSortedBy.standart) return;
    _sortListRepositories(event.sortedBy);

    emit(
      state.copyWith(sortedBy: event.sortedBy),
    );
  }

  void _onSearchEntriesCountChangedEvent(
      SearchEntriesCountChangedEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(entriesCount: event.entriesCount));
    add(SearchUpdateEvent());
  }

  void _onSearchPageChangedEvent(
      SearchPageChangedEvent event, Emitter<SearchState> emit) {
    if (event.page < 1) return;
    emit(state.copyWith(page: event.page));
    add(SearchUpdateEvent());
  }
}
