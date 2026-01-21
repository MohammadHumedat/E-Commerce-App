// This class to be implemented for managing application routes.

import 'package:e_commerce_app/view_model/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce_app/view_model/location_cubit/location_cubit.dart';
import 'package:e_commerce_app/view_model/payment_card/card_cubit.dart';
import 'package:e_commerce_app/view_model/product_details/product_details_cubit.dart';
import 'package:e_commerce_app/views/pages/checkout_page.dart';
import 'package:e_commerce_app/views/pages/add_new_card.dart';
import 'package:e_commerce_app/views/pages/chosen_address.dart';
import 'package:e_commerce_app/views/pages/login_page.dart';
import 'package:e_commerce_app/views/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/views/pages/custom_navbar_bottom.dart';
import 'package:e_commerce_app/views/pages/product_details_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const CustomBottomNavBar());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/checkout_page':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AddCardCubit()..loadCards()),
              BlocProvider(
                create: (context) {
                  final cubit = CheckoutCubit();
                  cubit.loadCheckoutData();
                  return cubit;
                },
              ),
            ],
            child: const CheckoutPage(),
          ),
        );
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
      case '/payment_method':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddCardCubit(),
            child: const AddNewCard(),
          ),
        );

      case '/chosen_location':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = LocationCubit();
              cubit.fetchLocations();
              return cubit;
            },
            child: const ChosenAddress(),
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
