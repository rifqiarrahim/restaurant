import 'package:flutter/material.dart';
import 'package:resto/data/api/search_api.dart';
import 'package:resto/data/model/Search.dart';

enum SearchState { Loading, NoData, HasData, Error }

class SearchProvider extends ChangeNotifier {
  final api_search apiService;
  final String keyword;

  SearchProvider({required this.apiService, required this.keyword}) {
    _fetchAllDetail();
  }

  late SearchResult _searchsResult;
  String _message = '';
  late SearchState _state;

  String get message => _message;

  SearchResult get result => _searchsResult;

  SearchState get state => _state;

  Future<dynamic> _fetchAllDetail() async {
    try {
      _state = SearchState.Loading;
      notifyListeners();
      final restaurant = await api_search.searchlist(query: keyword);
      if (restaurant.restaurants.isEmpty) {
        _state = SearchState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = SearchState.HasData;
        notifyListeners();
        return _searchsResult = restaurant;
      }
    } catch (e) {
      _state = SearchState.Error;
      notifyListeners();
      return _message = 'Not Connected';
    }
  }
}