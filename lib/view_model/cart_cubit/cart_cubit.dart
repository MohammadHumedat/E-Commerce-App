import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCartItems() async{
    emit(CartPageLoading());
    emit(CartPageLoaded(addToCartItems));
  }

  Future<void> updateQuantity(AddToCartModel item, int newQuantity) async {
    final index = addToCartItems.indexOf(item);
    if (index != -1) {
      addToCartItems[index] = AddToCartModel(
        Id: item.Id,
        product: item.product,
        quantity: newQuantity,
        size: item.size,
      );

      emit(CartPageLoaded(List.from(addToCartItems)));
    }
  }
}
