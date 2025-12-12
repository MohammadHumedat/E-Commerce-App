import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/view_model/checkout_cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.loadCheckoutData();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),

        bottomNavigationBar:
            _buildBottomActionBar(), // Extracted Bottom Action Bar
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          buildWhen: (previous, current) =>
              current is CheckoutLoadedState ||
              current is CheckoutLoadingState ||
              current is CheckoutErrorState,
          builder: (context, state) {
            if (state is CheckoutLoadingState) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is CheckoutErrorState) {
              return Center(
                child: Text('Something went wrong: ${state.message}'),
              );
            } else if (state is CheckoutLoadedState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      [
                            // 1. Delivery Address Section
                            _buildSectionHeader('Delivery Address'),
                            const SizedBox(height: 10),
                            // Address Card
                            _buildAddressCard(),

                            const SizedBox(height: 24),

                            // 2. Products List Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionHeader('Order List'),
                                Text(
                                  '${state.numOfProduct} Items',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: List.generate(
                                  state.cartItems.length,
                                  (index) {
                                    final item = state.cartItems[index];
                                    final isLast =
                                        index == state.cartItems.length - 1;
                                    return Column(
                                      children: [
                                        _buildCartItem(item),
                                        if (!isLast)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Dash(
                                              direction: Axis.horizontal,
                                              length:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  72,
                                              dashLength: 5,
                                              dashColor: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 3. Payment Method Section
                            _buildSectionHeader('Payment Method'),
                            const SizedBox(height: 10),
                            _buildPaymentCard(),

                            const SizedBox(height: 24),

                            // 4. Order Summary
                            _buildSectionHeader('Order Summary'),
                            const SizedBox(height: 10),
                            _buildOrderSummary(state),

                            const SizedBox(height: 100),
                          ]
                          .animate(interval: 50.ms)
                          .fade(duration: 600.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Section Header Widget

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '123 Main Street, New York, USA',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item) {
    // Replace 'dynamic' with your actual CartItem model type
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Image Placeholder (Modern Rounded Square)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(item.product.imgURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: Colors.blue),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '**** **** **** 4582',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Radio(
            value: true,
            groupValue: true,
            activeColor: Colors.blue,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CheckoutLoadedState state) {
    // Calculate total if not available in state
    double subtotal = state.cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    double shipping = 10.0; // Example static value
    double total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _summaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? Colors.blue : Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // here goes the payment confirmation logic, here i want to add logic to clear cart after payment
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Confirm Payment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
