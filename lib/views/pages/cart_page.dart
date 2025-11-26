
import 'package:e_commerce_app/view_model/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    return Scaffold(
      body: BlocBuilder<CartCubit, CartState>(
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
                  ListView.separated(
                    itemCount: cartItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItem(
                        item: item,
                        onRemove: () => cubit.removeItem(index),
                      );
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
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
