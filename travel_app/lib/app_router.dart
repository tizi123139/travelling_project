import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/hotel_page.dart';
import 'pages/map_page.dart';
import 'pages/food_page.dart';
import 'pages/culture_page.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/hotel':
        return MaterialPageRoute(builder: (_) => const HotelPage());
      case '/map':
        return MaterialPageRoute(builder: (_) => const MapPage());
      case '/food':
        return MaterialPageRoute(builder: (_) => const FoodPage());
      case '/culture':
        return MaterialPageRoute(builder: (_) => const CulturePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('没有找到页面: ${settings.name}'),
            ),
          ),
        );
    }
  }
}