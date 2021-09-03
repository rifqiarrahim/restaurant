import 'dart:convert';

import 'package:resto/data/model/Search.dart';
import 'package:http/http.dart' as http;

class api_search {
  static Future<SearchResult> searchlist({required String query}) async {
    final String _baseUrl = 'https://restaurant-api.dicoding.dev/search?q='+query;
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurant');
    }
  }
}