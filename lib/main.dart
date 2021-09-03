import 'package:flutter/material.dart';
import 'package:resto/ui/RestaurantDetailPage.dart';
import 'package:resto/ui/search_page.dart';
import 'ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'makan yuk',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
          ModalRoute.of(context)?.settings.arguments as String,
        ),
        RestaurantSearchPage.routeName: (context) => RestaurantSearchPage(
          ModalRoute.of(context)?.settings.arguments as String,
        ),
      },
    );
  }
}