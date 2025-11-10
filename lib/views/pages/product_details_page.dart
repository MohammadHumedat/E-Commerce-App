import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.black,
        ),
      ),
      body: Center(
        child: Text(
          'Product Details Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
