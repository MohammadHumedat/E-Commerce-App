import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/view_model/product_details/product_details_cubit.dart';
import 'package:e_commerce_app/views/widgets/counter_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: BlocProvider.of<ProductDetailsCubit>(context),
      buildWhen: (_, current) => current is! ProductQuantity,
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
            extendBodyBehindAppBar: true,

            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // IMAGE
                      CachedNetworkImage(
                        imageUrl: product.imgURL,
                        width: double.infinity,
                        height: 380,
                        fit: BoxFit.cover,
                      ),

                      // TRANSPARENT APPBAR
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DETAILS CONTAINER
                      Positioned(
                        top: 320,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // PRODUCT NAME
                                    product.productName,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //--------- COUNTER WIDGET ----------
                                  BlocBuilder<
                                    ProductDetailsCubit,
                                    ProductDetailsState
                                  >(
                                    bloc: BlocProvider.of<ProductDetailsCubit>(
                                      context,
                                    ),
                                    buildWhen: (_, current) =>
                                        current is ProductDetailsLoaded ||
                                        current is ProductQuantity,
                                    builder: (context, state) {
                                      if (state is! ProductDetailsLoaded &&
                                          state is! ProductQuantity) {
                                        return const SizedBox.shrink();
                                      } else if (state is ProductQuantity) {
                                        return CounterProduct(
                                          value: state.quantity,
                                          productId: productId,
                                          cubit:
                                              BlocProvider.of<
                                                ProductDetailsCubit
                                              >(context),
                                        );
                                      } else if (state
                                          is ProductDetailsLoaded) {
                                        return CounterProduct(
                                          value: state.product.quantity,
                                          productId: productId,
                                          cubit:
                                              BlocProvider.of<
                                                ProductDetailsCubit
                                              >(context),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              Text(product.category), // PRODUCT CATEGORY
                              const SizedBox(height: 20),
                              Text(
                                '\$ ${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 300,
                              ), // Space for scrolling
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 350),
                ],
              ),
            ),

            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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
