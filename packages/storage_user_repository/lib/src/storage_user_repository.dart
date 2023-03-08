import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:search_user_repository/search_user_repository.dart';

class StorageUserRepository {
  Future<List<GitRepository>> getRepositoriesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> repositories = prefs.getStringList('repositories') ?? [];
    final List<GitRepository> modelRepositories = [];
    for (final repos in repositories) {
      final Map<String, dynamic> reposMap = jsonDecode(repos);
      modelRepositories.add(GitRepository.fromJson(reposMap));
    }
    return modelRepositories;
  }

  void setRepositoriesToLocalStorage(List<GitRepository> repositories) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stringRepositories = [];
    for (final repos in repositories) {
      stringRepositories.add(jsonEncode(repos.toJson()));
    }
    prefs.setStringList('repositories', stringRepositories);
  }
}
