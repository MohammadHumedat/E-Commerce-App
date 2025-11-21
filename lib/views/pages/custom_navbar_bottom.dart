import 'package:e_commerce_app/view_model/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/view_model/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:e_commerce_app/views/pages/cart_page.dart';
import 'package:e_commerce_app/views/pages/favorite_page.dart';
import 'package:e_commerce_app/views/pages/home_page.dart';
import 'package:e_commerce_app/views/pages/profile_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late final PersistentTabController _controller;

  final List<PersistentTabConfig> _tabs = [
    PersistentTabConfig(
      screen: BlocProvider(
        create: (context) {
          final cubit = HomeCubit();
          cubit.loadHomeData();
          return cubit;
        },
        child: const HomePage(),
      ),
      item: ItemConfig(icon: const Icon(Icons.home), title: 'Home'),
    ),
    PersistentTabConfig(
      screen: BlocProvider(
        create: (context) {
          final cubit = CartCubit();
          cubit.getCartItems();
          return cubit;
        },
        child: const CartPage(),
      ),
      item: ItemConfig(icon: const Icon(Icons.shopping_cart), title: 'Cart'),
    ),
    PersistentTabConfig(
      screen: const ProfilePage(),
      item: ItemConfig(icon: const Icon(Icons.person), title: 'Profile'),
    ),
    PersistentTabConfig(
      screen: const FavoritePage(),
      item: ItemConfig(icon: const Icon(Icons.favorite), title: 'Favorites'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _tabs,
      backgroundColor: Colors.white,
      stateManagement: false,
      keepNavigatorHistory: true,
      resizeToAvoidBottomInset: true,
      handleAndroidBackButtonPress: true,
      navBarOverlap: const NavBarOverlap.none(),
      margin: const EdgeInsets.all(8.0),
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -1),
            ),
          ],
        ),
      ),
    );
  }
}
