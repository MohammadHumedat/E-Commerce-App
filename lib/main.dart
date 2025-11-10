import 'package:e_commerce_app/utils/app_router.dart';
import 'package:e_commerce_app/views/pages/custom_navbar_bottom.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce',
     onGenerateRoute: AppRouter.onGenerateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:const CustomBottomNavBar(),
    );
  }
}
