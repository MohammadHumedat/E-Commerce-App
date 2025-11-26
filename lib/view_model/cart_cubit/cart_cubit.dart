import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';


part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCartItems() async {
    emit(CartPageLoading());
    emit(CartPageLoaded(addToCartItems));
  }

  Future<void> updateQuantityById(int productId, int newQuantity) async {
  final index = addToCartItems.indexWhere((item) => item.product.id == productId);

  if (index != -1) {
    addToCartItems[index] = addToCartItems[index].copyWith(
      quantity: newQuantity,
    );

    emit(CartPageLoaded(List.from(addToCartItems)));
  }
}

  // Remove the item when click on remove item.
  Future<void> removeItem(int index) async {
  addToCartItems.removeAt(index);
  emit(CartPageLoaded(List.from(addToCartItems)));
}
}
