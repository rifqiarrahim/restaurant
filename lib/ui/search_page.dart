import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/ui/RestaurantDetailPage.dart';
import 'package:resto/data/api/search_api.dart';
import 'package:resto/provider/search_provider.dart';

import '../data/model/Search.dart';


class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/restaurant_search';

  final String keyword;
  RestaurantSearchPage(this.keyword);

  @override
  Widget build(BuildContext context){
    return Scaffold (
      appBar: AppBar(
        title: Text(keyword),

      ),
      body:
      ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(apiService: api_search(), keyword: keyword),
        child: RestaurantSearchList(),
      ),
    );
  }

}
class RestaurantSearchList extends StatelessWidget {
  Widget _buildList() {
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
        if (state.state == SearchState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == SearchState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (state.state == SearchState.NoData) {
          return Center(child: Text("Restaurant tidak ditemukan"));
        } else if (state.state == SearchState.Error) {
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
class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.network(
                "https://restaurant-api.dicoding.dev/images/small/"+restaurant.pictureId,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15,top: 15),
                    child: Row(
                        children: [
                          Icon(Icons.restaurant_menu_outlined, size:15,),
                          Text(restaurant.name, style: TextStyle(fontSize: 15),),
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 15,),
                        Text(restaurant.city, style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Icon(Icons.star_border_outlined, size: 15,),
                        Text(restaurant.rating.toString(),style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FavoriteButton(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        onTap:(){
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurant.id);
        },
      ),
    );
  }
}
class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}