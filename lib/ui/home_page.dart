
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/ui/RestaurantDetailPage.dart';
import 'package:resto/data/model/restaurant.dart';
import 'package:resto/provider/resto_provider.dart';
import 'package:resto/data/api/api_service.dart';
import 'package:resto/ui/search_page.dart';
class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _listWidget = [
    ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(apiService: ApiService()),
        child: RestaurantList(),
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder:(context, isScrolled){
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/resto.jpg',
                fit: BoxFit.fitWidth,
              ),
              title: Text('Restaurant'),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                ),
                  onSubmitted: (String value){
                    Navigator.pushNamed(context, RestaurantSearchPage.routeName,
                      arguments: value);
                  },
              ),
            ),
          ),
        ];
      },
        body: _listWidget[0],
      ),
    );

  }
}
class RestaurantList extends StatefulWidget {
  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  Widget _buildList() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
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
                  ),
                ],
              ),
            ),
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