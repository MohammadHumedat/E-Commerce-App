part of 'cart_cubit.dart';

class CartState {}

final class CartInitial extends CartState {}

final class CartPageLoading extends CartState {}

final class CartPageLoaded extends CartState {
  CartPageLoaded(this.cartItems, this.totalPrice);

  final List<AddToCartModel> cartItems;
  final double totalPrice;
}

final class CartPageError extends CartState {
  CartPageError(this.message);
  final String message;
}

final class CartItemRemoved extends CartState {
  CartItemRemoved(this.productId);
  final String productId;
}
