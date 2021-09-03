import 'dart:convert';

import 'package:resto/data/model/detail.dart';
import 'package:http/http.dart' as http;

class api_detail {
  static Future<DetailResult> listdetail({required String id}) async {
    final String _baseUrl = 'https://restaurant-api.dicoding.dev/detail/'+id;
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurant');
    }
  }
}