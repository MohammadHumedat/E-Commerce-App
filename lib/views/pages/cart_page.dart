import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/Constants/app_routes.dart';
import 'package:e_commerce_app/view_model/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    return BlocBuilder<CartCubit, CartState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is CartPageLoaded ||
          current is CartPageLoading ||
          current is CartPageError,
      builder: (context, state) {
        if (state is CartPageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartPageError) {
          return Center(child: Text(state.massage));
        } else if (state is CartPageLoaded) {
          final cartItems = state.cartItems;
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                ListView.separated(
                  itemCount: cartItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartItem(item: item);
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 1.2,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      totalAndSubTotalAmount(
                        context,
                        'Subtotal',
                        state.totalPrice,
                      ),
                      const SizedBox(height: 12),
                      totalAndSubTotalAmount(context, 'Shipping', 10),
                      const SizedBox(height: 12),
                      Dash(
                        direction: Axis.horizontal,
                        length: MediaQuery.of(context).size.width - 72,
                        dashLength: 8,
                        dashColor: Colors.grey[300]!,
                      ),
                      const SizedBox(height: 12),
                      totalAndSubTotalAmount(
                        context,
                        'Total Amount',
                        state.totalPrice + 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Checkout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to checkout page
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.checkoutPage);
                      },
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget totalAndSubTotalAmount(context, String title, double amount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.grey2,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
