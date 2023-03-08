part of 'favorite_repositories_bloc.dart';

abstract class FavoriteRepositoriesEvent extends Equatable {
  const FavoriteRepositoriesEvent();

  @override
  List<Object> get props => [];
}

class FavoriteRepositoriesAddEvent extends FavoriteRepositoriesEvent {
  final GitRepository repos;
  const FavoriteRepositoriesAddEvent(this.repos);
}

class FavoriteRepositoriesDeleteEvent extends FavoriteRepositoriesEvent {
  final int reposIndex;

  const FavoriteRepositoriesDeleteEvent({this.reposIndex = 0});
  @override
  List<Object> get props => [reposIndex];
}

class FavoriteRepositoriesLoadingEvent extends FavoriteRepositoriesEvent {}

class FavoriteRepositoriesInitialEvent extends FavoriteRepositoriesEvent {}

class FavoriteRepositoriesClearEvent extends FavoriteRepositoriesEvent {}

class FavorireRepositoriesReorderEvent extends FavoriteRepositoriesEvent {
  final int oldIndex;
  final int newIndex;
  const FavorireRepositoriesReorderEvent(
      {this.oldIndex = 0, this.newIndex = 1});

  @override
  List<Object> get props => [oldIndex, newIndex];
}
