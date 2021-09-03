import 'package:flutter/material.dart';
import 'package:resto/data/api/detail_api.dart';
import 'package:resto/data/model/detail.dart';

enum ResultState { Loading, NoData, HasData, Error }

class DetailProvider extends ChangeNotifier {
  final api_detail apiService;
  final String id_restaurant;

  DetailProvider({required this.apiService, required this.id_restaurant}) {
    _fetchAllDetail();
  }

  late DetailResult _detailsResult;
  String _message = '';
  late ResultState _state;

  String get message => _message;

  DetailResult get result => _detailsResult;

  ResultState get state => _state;

  Future<dynamic> _fetchAllDetail() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await api_detail.listdetail(id: id_restaurant);
      if (restaurant.restaurants.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailsResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Not Connected';
    }
  }
}