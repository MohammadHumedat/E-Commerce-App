// This class to be implemented for managing application routes.
import 'package:flutter/material.dart';
import 'package:e_commerce_app/views/pages/custom_navbar_bottom.dart';
import 'package:e_commerce_app/views/pages/product_details_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const CustomBottomNavBar());

      case '/product_details':
        return MaterialPageRoute(builder: (_) => const ProductDetailsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
