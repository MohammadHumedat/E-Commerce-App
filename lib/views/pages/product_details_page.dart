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
    final cubit = context.read<ProductDetailsCubit>();

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (_, current) =>
          current is ProductDetailsLoading ||
          current is ProductDetailsLoaded ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductDetailsError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is! ProductDetailsLoaded) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => cubit.fetchProductDetails(productId),
                child: const Text('Load Product Details'),
              ),
            ),
          );
        }

        final product = state.product;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              /// --- HEADER WITH IMAGE ---
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                backgroundColor: Colors.black,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: product.imgURL,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 80),
                  ),
                ),

                /// BACK BUTTON
                leading: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                /// FAVORITE BUTTON
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
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
                  ),
                ],
              ),

              /// --- PRODUCT DETAILS SECTION ---
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(0, -4),
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// TITLE + COUNTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// PRODUCT NAME
                          Expanded(
                            child: Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          /// COUNTER (only this part rebuilds)
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            buildWhen: (_, current) =>
                                current is ProductQuantity ||
                                current is ProductDetailsLoaded,
                            builder: (context, newState) {
                              final quantity = newState is ProductQuantity
                                  ? newState.quantity
                                  : product.quantity;

                              return const ModernCounter(initialValue: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          /// CATEGORY LABEL
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          /// STOCK LABEL
                          Text(
                            'In Stock: ${product.quantity}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SIZE OPTIONS
                      Text(
                        'Size',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                        bloc: cubit,
                        buildWhen: (_, current) =>
                            current is ProductSizeSelected ||
                            current is ProductDetailsLoaded,
                        builder: (context, state) {
                          return Row(
                            children: ProductSize.values.map((size) {
                              final isSelected = size == product.size;

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    cubit.selectSize(product.id, size);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : Colors.grey.shade400,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      size.name.toUpperCase(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      /// DESCRIPTION LABEL
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// DESCRIPTION TEXT
                      Text(
                        '${product.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 300),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// --- ADD TO CART ---
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// PRICE DISPLAY
                  Expanded(
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // ADD TO CART BUTTON
                  BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                    bloc: cubit,
                    buildWhen: (_, current) =>
                        current is ProductAddingToCart ||
                        current is ProductAddedToCart,
                    builder: (context, state) {
                      final bool isLoading = state is ProductAddingToCart;

                      return SizedBox(
                        width: 200,
                        height: 55,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),

                          child: isLoading
                              ? Container(
                                  key: const ValueKey('loading'),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.3,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Adding...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  key: const ValueKey('normal'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    cubit.addToCart(productId);
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
