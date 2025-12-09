part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutCubitInitial extends CheckoutState {}

final class CheckoutLoadingState extends CheckoutState {}

final class CheckoutLoadedState extends CheckoutState {
  CheckoutLoadedState({
    required this.cartItems,
    required this.totalPrice,
    required this.numOfProduct,
  });
  final List<AddToCartModel> cartItems;
  final double totalPrice;
  final int numOfProduct;
}

final class CheckoutErrorState extends CheckoutState {
  CheckoutErrorState(this.message);
  final String message;
}
