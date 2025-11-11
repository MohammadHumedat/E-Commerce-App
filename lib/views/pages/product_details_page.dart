import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/view_model/product_details/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) {
    final product = productItems.firstWhere((p) => p.id == productId);

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: BlocProvider.of<ProductDetailsCubit>(context),
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (state is ProductDetailsLoaded) {
          // Use the loaded product details from the state
          final product = state.product;
          return Scaffold(
            appBar: AppBar(
              title: Text(product.productName),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imgURL,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description ?? 'No description available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Initial state or any other unhandled state
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ProductDetailsCubit>(
                    context,
                  ).fetchProductDetails(productId);
                },
                child: const Text('Load Product Details'),
              ),
            ),
          );
        }
      },
    );
  }
}
