import 'package:dio/dio.dart';
import 'package:search_user_repository/search_user_repository.dart';

class SearchUserRepository {
  final apiUrl = 'https://api.github.com/search/repositories';

  final _httpClient = Dio();

  Future<bool> isSearchNextPageEmpty(
      {String query = '', required int page}) async {
    try {
      final res = await _httpClient.get('$apiUrl?q=$query&page=${page + 1}');
      return (res.data['items'] as List).isEmpty;
    } catch (e) {
      return true;
    }
  }

  Future<List<GitRepository>> onSearchToModel(
      {String query = '', int perPage = 25, int page = 1}) async {
    try {
      final res = await _httpClient
          .get('$apiUrl?q=$query&per_page=$perPage&page=$page');
      return (res.data['items'] as List)
          .map((json) => GitRepository.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
