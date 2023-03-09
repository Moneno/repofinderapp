import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:search_user_repository/search_user_repository.dart';

class StorageUserRepository {
  Future<List<GitRepository>> getRepositoriesFromLocalStorage() async {
    final List<GitRepository>? repositories =
        Hive.box<List>('favorite_repositories')
            .get('repositories')
            ?.cast<GitRepository>();

    return repositories ?? [];
  }

  void setRepositoriesToLocalStorage(List<GitRepository> repositories) async {
    Hive.box<List>('favorite_repositories').put('repositories', repositories);
  }

  void clearRepositoriesFromLocalStorage() {
    Hive.box<List>('favorite_repositories').clear();
  }
}
