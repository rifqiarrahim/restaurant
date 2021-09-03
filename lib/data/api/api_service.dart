import 'dart:convert';
import 'package:resto/data/model/restaurant.dart';
import 'package:http/http.dart' as http;
class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantResult> listrestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl+"list"));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurant');
    }
  }
}
