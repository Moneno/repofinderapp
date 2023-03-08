import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_user_repository/search_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_user_repository/storage_user_repository.dart';

part 'favorite_repositories_event.dart';
part 'favorite_repositories_state.dart';

class FavoriteRepositoriesBloc
    extends Bloc<FavoriteRepositoriesEvent, FavoriteRepositoriesState> {
  FavoriteRepositoriesBloc(
      {required StorageUserRepository storageUserRepository})
      : _storageUserRepository = storageUserRepository,
        super(const FavoriteRepositoriesState()) {
    on<FavoriteRepositoriesInitialEvent>(_onInitial);
    on<FavoriteRepositoriesAddEvent>(_onAdd);
    on<FavoriteRepositoriesDeleteEvent>(_onDelete);
    on<FavoriteRepositoriesClearEvent>(_onClear);
    on<FavorireRepositoriesReorderEvent>(_onReorder);
  }

  late final StorageUserRepository _storageUserRepository;
  final List<String> reposUrls = [];
  late final List<GitRepository> repositories;

  Future<void> _onInitial(FavoriteRepositoriesInitialEvent event,
      Emitter<FavoriteRepositoriesState> emit) async {
    if (state.status == FavoriteRepositoriesStatus.initialized) return;
    repositories =
        await _storageUserRepository.getRepositoriesFromLocalStorage();
    for (final repos in repositories) {
      reposUrls.add(repos.reposUrl ?? '');
    }
    emit(state.copyWith(
        repositories: repositories,
        reposUrls: reposUrls,
        status: FavoriteRepositoriesStatus.initialized));
  }

  void _onAdd(FavoriteRepositoriesAddEvent event,
      Emitter<FavoriteRepositoriesState> emit) {
    emit(state.copyWith(status: FavoriteRepositoriesStatus.loading));
    repositories.add(event.repos);
    reposUrls.add(event.repos.reposUrl ??
        'https://github.com/${event.repos.username}/${event.repos.reposName}');
    _storageUserRepository.setRepositoriesToLocalStorage(repositories);
    emit(state.copyWith(
      repositories: repositories,
      status: FavoriteRepositoriesStatus.update,
      reposUrls: reposUrls,
    ));
    // prefs.
    // emit(state.copyWith(repositories: state.repositories.add(event.repos)))
  }

  void _onDelete(FavoriteRepositoriesDeleteEvent event,
      Emitter<FavoriteRepositoriesState> emit) {
    emit(state.copyWith(status: FavoriteRepositoriesStatus.loading));
    repositories.removeAt(event.reposIndex);
    reposUrls.removeAt(event.reposIndex);
    _storageUserRepository.setRepositoriesToLocalStorage(repositories);
    emit(state.copyWith(
      repositories: repositories,
      status: FavoriteRepositoriesStatus.update,
      reposUrls: reposUrls,
    ));
  }

  void _onClear(FavoriteRepositoriesClearEvent event,
      Emitter<FavoriteRepositoriesState> emit) {
    emit(state.copyWith(status: FavoriteRepositoriesStatus.loading));
    repositories.clear();
    reposUrls.clear();
    _storageUserRepository.setRepositoriesToLocalStorage(repositories);
    emit(state.copyWith(
      reposUrls: reposUrls,
      repositories: repositories,
      status: FavoriteRepositoriesStatus.update,
    ));
  }

  void _onReorder(FavorireRepositoriesReorderEvent event,
      Emitter<FavoriteRepositoriesState> emit) {
    emit(state.copyWith(status: FavoriteRepositoriesStatus.loading));
    int newIndex = event.newIndex;
    if (event.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GitRepository item = repositories.removeAt(event.oldIndex);
    repositories.insert(newIndex, item);
    emit(state.copyWith(
      repositories: repositories,
      status: FavoriteRepositoriesStatus.update,
      newIndex: newIndex,
    ));
  }
}
