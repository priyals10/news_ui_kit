import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:news_ui_kit/features/home/data/models/news_article_model.dart';

/// Handles all raw HTTP calls to NewsAPI.
/// Returns data-layer models (not entities).
class NewsRemoteDataSource {
  static const String _apiKey = 'e8d8d64d78fc48dfbdb7e746c39b0f14';
  static const String _baseUrl = 'https://newsapi.org/v2';

  static const String _noInternetMessage =
      'No internet connection. Please check your network and try again.';

  /// Fetches top headlines JSON and returns a list of [NewsArticleModel].
  Future<List<NewsArticleModel>> fetchTopHeadlines({String country = 'us'}) async {
    final uri = Uri.parse(
      '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['articles'] as List)
            .map((json) => NewsArticleModel.fromJson(json))
            .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
            .toList();
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(_noInternetMessage);
    } on http.ClientException {
      throw Exception(_noInternetMessage);
    }
  }

  /// Fetches top headlines filtered by [category].
  Future<List<NewsArticleModel>> fetchTopHeadlinesByCategory({
    String country = 'us',
    required String category,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/top-headlines?country=$country&category=$category&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['articles'] as List)
            .map((json) => NewsArticleModel.fromJson(json))
            .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
            .toList();
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(_noInternetMessage);
    } on http.ClientException {
      throw Exception(_noInternetMessage);
    }
  }

  /// Searches articles by keyword using the /everything endpoint.
  Future<List<NewsArticleModel>> searchArticles({required String query}) async {
    final uri = Uri.parse(
      '$_baseUrl/everything?q=${Uri.encodeComponent(query)}&sortBy=publishedAt&pageSize=20&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['articles'] as List)
            .map((json) => NewsArticleModel.fromJson(json))
            .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
            .toList();
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(_noInternetMessage);
    } on http.ClientException {
      throw Exception(_noInternetMessage);
    }
  }
}

