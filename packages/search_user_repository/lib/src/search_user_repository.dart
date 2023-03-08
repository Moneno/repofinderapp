import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:search_user_repository/search_user_repository.dart';

class SearchUserRepository {
  final apiUrl = 'https://api.github.com/search/repositories';
  String accessToken = '';
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
      if (accessToken.isEmpty) {
        accessToken =
            await rootBundle.loadString('assets/access_token/access_token.txt');
        _httpClient.options.headers = {'Authorization': 'token $accessToken'};
      }

      final res = await _httpClient.get(
        '$apiUrl?q=$query&per_page=$perPage&page=$page',
      );
      return (res.data['items'] as List)
          .map((json) => GitRepository.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
