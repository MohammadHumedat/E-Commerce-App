part of 'cart_cubit.dart';


 class CartState {}

final class CartInitial extends CartState {}

final class CartPageLoading extends CartState{
}

final class CartPageLoaded extends CartState{
  CartPageLoaded( this.cartItems, {this.itemId =0});
 final List<AddToCartModel>cartItems;
 final int itemId; 
}
final class CartPageError extends CartState{
CartPageError(this.massage);
  final String massage;
}