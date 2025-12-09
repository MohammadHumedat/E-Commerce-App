import 'package:e_commerce_app/view_model/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/counter_product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item});

  final AddToCartModel item;

  @override
  Widget build(BuildContext context) {
    final cartCubit = BlocProvider.of<CartCubit>(context);

    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          current is CartPageLoaded ||
          current is CartPageLoading ||
          current is CartPageError,
      builder: (context, state) {
        if (state is CartPageLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartPageError) {
          return Center(child: Text(state.massage));
        }

        if (state is CartPageLoaded) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.product.imgURL,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Product Name
                        item.product.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      BlocBuilder<CartCubit, CartState>(
                        buildWhen: (previous, current) =>
                            current is CartPageLoaded,
                        builder: (context, state) {
                          if (state is CartPageLoaded) {
                            final currentItem = state.cartItems.firstWhere(
                              (element) =>
                                  element.product.id == item.product.id &&
                                  element.size == item.size,
                            );

                            return Text(
                              '\$${(currentItem.quantity * currentItem.product.price).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Size: ${item.size.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                //  Quantity + Remove
                Column(
                  children: [
                    ModernCounter(
                      value: item.quantity,
                      onIncrease: () {
                        cartCubit.updateQuantityById(
                          item.product.id,
                          item.quantity + 1,
                        );
                      },
                      onDecrease: () {
                        if (item.quantity > 1) {
                          cartCubit.updateQuantityById(
                            item.product.id,
                            item.quantity - 1,
                          );
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        cartCubit.removeItemById(item.product.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
