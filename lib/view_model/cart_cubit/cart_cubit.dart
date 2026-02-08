import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/cart_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  final _cartServices = CartServiceImp();
  void getCartItems() async {
    emit(CartPageLoading());
    final currentUser = AuthServiceImpl();
    final userId = currentUser.currentUser!.uid;
    final cartItems= await _cartServices.loadCartItems(userId);
    double totalPrice = addToCartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    emit(CartPageLoaded(cartItems, totalPrice));
  }

  Future<void> updateQuantityById(int productId, int newQuantity) async {
    final index = addToCartItems.indexWhere(
      // ignore: unrelated_type_equality_checks
      (item) => item.product.id == productId,
    );

    if (index != -1) {
      addToCartItems[index] = addToCartItems[index].copyWith(
        quantity: newQuantity,
      );

      double totalPrice = addToCartItems.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );
      emit(CartPageLoaded(List.from(addToCartItems), totalPrice));
    }
  }

  // Remove the item when click on remove item.
  Future<void> removeItemById(int productId) async {
    // ignore: unrelated_type_equality_checks
    addToCartItems.removeWhere((item) => item.product.id == productId);

    double totalPrice = addToCartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    emit(CartItemRemoved(productId));
    emit(CartPageLoaded(List.from(addToCartItems), totalPrice));
  }
}
