// This class to be implemented for managing application routes.
import 'package:e_commerce_app/view_model/product_details/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/views/pages/custom_navbar_bottom.dart';
import 'package:e_commerce_app/views/pages/product_details_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const CustomBottomNavBar());

      case '/product_details':
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductDetailsCubit();
              cubit.fetchProductDetails(productId);
              return cubit;
            },
            child: ProductDetailsPage(productId: productId),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
