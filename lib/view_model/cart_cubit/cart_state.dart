part of 'cart_cubit.dart';

class CartState {}

final class CartInitial extends CartState {}

final class CartPageLoading extends CartState {}

final class CartPageLoaded extends CartState {
  CartPageLoaded(this.cartItems, this.totalPrice, {this.itemId = 0});
  final List<AddToCartModel> cartItems;
  final int itemId;
  final double totalPrice;
}

final class CartPageError extends CartState {
  CartPageError(this.massage);
  final String massage;
}

final class CartItemRemoved extends CartState {
  CartItemRemoved(this.itemId);

  final int itemId;
}
