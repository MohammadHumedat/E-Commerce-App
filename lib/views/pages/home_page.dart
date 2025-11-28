import 'package:flutter/material.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TabBar(
          controller: _tabController,
          unselectedLabelColor: AppColors.grey1,
          labelColor: AppColors.primaryColor,
          indicatorColor: AppColors.primaryColor,

          tabs: const [
            Tab(text: 'Home'),
            Tab(text: 'Category'),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [HomeTabView(), CategoryTabView()],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
