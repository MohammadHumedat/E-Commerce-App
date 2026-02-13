import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/cart_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final _cartServices = CartServiceImp();
  final _authService = AuthServiceImpl();

  Future<void> getCartItems() async {
    emit(CartPageLoading());

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        emit(CartPageError('User not logged in'));
        return;
      }

      final cartItems = await _cartServices.loadCartItems(userId);

      final totalPrice = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(CartPageLoaded(cartItems, totalPrice));
    } catch (e) {
      emit(CartPageError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> updateQuantityById(String itemId, int newQuantity) async {
    final currentState = state;
    if (currentState is! CartPageLoaded) return;

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final updatedItems = currentState.cartItems.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();

      final totalPrice = updatedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(CartPageLoaded(updatedItems, totalPrice));

      await _cartServices.updateCartItemQuantity(userId, itemId, newQuantity);
    } catch (e) {
      await getCartItems();
      emit(CartPageError('Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> removeItemById(String itemId) async {
    final currentState = state;
    if (currentState is! CartPageLoaded) return;

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final updatedItems = currentState.cartItems
          .where((item) => item.id != itemId)
          .toList();

      final totalPrice = updatedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(CartItemRemoved(itemId));
      emit(CartPageLoaded(updatedItems, totalPrice));

      await _cartServices.removeCartItem(userId, itemId);
    } catch (e) {
      await getCartItems();
      emit(CartPageError('Failed to remove item: ${e.toString()}'));
    }
  }
}
