part of 'favorite_repositories_bloc.dart';

enum FavoriteRepositoriesStatus {
  initial,
  initialized,
  loading,
  success,
  update,
  failure
}

class FavoriteRepositoriesState extends Equatable {
  final List<String> reposUrls;
  final FavoriteRepositoriesStatus status;
  final List<GitRepository> repositories;
  final int newIndex;
  const FavoriteRepositoriesState({
    this.newIndex = 0,
    this.reposUrls = const [],
    this.status = FavoriteRepositoriesStatus.initial,
    this.repositories = const [],
  });

  FavoriteRepositoriesState copyWith(
      {FavoriteRepositoriesStatus? status,
      List<GitRepository>? repositories,
      int? newIndex,
      List<String>? reposUrls}) {
    return FavoriteRepositoriesState(
      repositories: repositories ?? this.repositories,
      status: status ?? this.status,
      reposUrls: reposUrls ?? this.reposUrls,
      newIndex: newIndex ?? this.newIndex,
    );
  }

  @override
  List<Object> get props => [status, repositories, reposUrls, newIndex];
}
