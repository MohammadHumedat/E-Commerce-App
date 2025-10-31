import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/views/widgets/category_tab_view.dart';
import 'package:e_commerce_app/views/widgets/home_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Important Note: Tab controller works in stateful not stateless.
  late TabController _TabController;

  @override
  void initState() {
    _TabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        // circle Photo in the App bar (using Cached Network Image).
                        backgroundImage: CachedNetworkImageProvider(
                          'https://media.istockphoto.com/id/1457536828/photo/japanese-young-man-enjoy-traveling-alone.webp?a=1&s=612x612&w=0&k=20&c=S4hwiclbLQV2aMlztJVdjUuXEAMhYuuw2ifKERrAw44=',
                        ),

                        radius: 25,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        // Text behind the circle photo
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mohammad Hmedat',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Let\'s go shopping!',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ), // Row 1
                  Row(
                    // The icons at the end of App bar.
                    // Row 2
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              TabBar(
                controller: _TabController,
                unselectedLabelColor: AppColors.grey,
                labelColor: AppColors.primaryColor,
                indicatorColor: AppColors.primaryColor,

                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Category'),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _TabController,
                  children: const [HomeTabView(), CategoryTabView()],
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
