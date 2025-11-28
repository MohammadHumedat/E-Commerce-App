import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
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

  int get selectedIndex => _controller.index;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    _controller.addListener(() {
      setState(() {});
    });
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,

          leadingWidth: 60,
          leading: const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(
                'https://media.istockphoto.com/id/1457536828/photo/japanese-young-man-enjoy-traveling-alone.webp?a=1&s=612x612&w=0&k=20&c=S4hwiclbLQV2aMlztJVdjUuXEAMhYuuw2ifKERrAw44=',
              ),
            ),
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mohammad Hmedat',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Let\'s go shopping!',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          actions: [
            if (selectedIndex == 0) ...[
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
            ],
            if (selectedIndex == 1) ...[
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
            ],
            if (selectedIndex == 2) ...[
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
            if (selectedIndex == 3) ...[
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ],
        ),
      ),

      body: PersistentTabView(
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
      ),
    );
  }
}
