import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/data/api/detail_api.dart';
import 'package:resto/provider/detail_provider.dart';

import '../data/model/detail.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String id_resto;
  RestaurantDetailPage(this.id_resto);

  @override

  Widget build(BuildContext context){
    return Scaffold (
      body: //Text(id_resto),
      ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(apiService: api_detail(), id_restaurant: id_resto,),
        child: DetailList(),
      ),
    );
  }

}
class DetailContent extends StatelessWidget {
  final Restaurant restaurant;

  const DetailContent({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network("https://restaurant-api.dicoding.dev/images/medium/"+restaurant.pictureId),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Text(
                restaurant.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined),
                Text(
                  restaurant.address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                restaurant.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Text(
                "Categories",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: restaurant.categories.map((category) {
                  return Chip(
                    label: Text(category.name),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Text(
                "Food",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: restaurant.menus.foods.map((food) {
                  return Chip(
                    label: Text(food.name),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:16.0),
              child: Text(
                "Drink",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: restaurant.menus.drinks.map((drink) {
                  return Chip(
                    label: Text(drink.name),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:16.0),
              child: Text(
                "Review",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: restaurant.customerReviews.map((review) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0,top: 5.0, bottom:5.0),
                              child: Icon(Icons.account_box_outlined),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0,top: 5.0, bottom:5.0),
                              child: Text(
                                review.name,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            review.review,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            review.date,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class DetailList extends StatelessWidget {
  Widget _buildList() {
    return Consumer<DetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurant = state.result.restaurants;
          return DetailContent(restaurant: restaurant);
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }
}