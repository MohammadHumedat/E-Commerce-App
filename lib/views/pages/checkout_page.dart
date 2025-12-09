import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/view_model/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce_app/views/widgets/checkout_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.loadCheckoutData(); // Pass actual cart items here
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          backgroundColor: AppColors.scaffoldBackground,
        ),
        body: Builder(
          builder: (context) {
            return BlocBuilder<CheckoutCubit, CheckoutState>(
              buildWhen: (previous, current) =>
                  current is CheckoutLoadedState ||
                  current is CheckoutLoadingState ||
                  current is CheckoutErrorState,
              bloc: BlocProvider.of<CheckoutCubit>(context),
              builder: (context, state) {
                if (state is CheckoutLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CheckoutErrorState) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is CheckoutLoadedState) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Checkout Page',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'This is where the checkout process will take place.',
                            style: TextStyle(fontSize: 16),
                          ),
                          // Add more checkout related widgets here
                          CheckoutHeadline(
                            title: 'Address',

                            onTap: () {
                              // Handle edit action
                            },
                          ),
                          CheckoutHeadline(
                            title: 'Products',
                            productNumbers: state.numOfProduct,
                          ),
                          const SizedBox(height: 10),
                          const CheckoutHeadline(title: 'Payment'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Initializing...'));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
