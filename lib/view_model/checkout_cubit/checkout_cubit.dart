import 'package:e_commerce_app/models/Payment_cart_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutCubitInitial());
  void loadCheckoutData() {
    emit(CheckoutLoadingState());
    try {
      // Simulate data processing
      final cartItems = addToCartItems;
      final subTotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.product.price * item.quantity,
      );
      final numOfProduct = cartItems.fold<int>(
        0,
        (previous, element) => previous + element.quantity,
      );
      final chosenPaymentCard = dummyPaymentCardList.isNotEmpty
          ? dummyPaymentCardList.first
          : null;
      emit(
        CheckoutLoadedState(
          cartItems: cartItems,
          totalPrice: subTotal + 10,
          numOfProduct: numOfProduct,
          paymentCards: chosenPaymentCard,
        ),
      );
    } catch (e) {
      emit(CheckoutErrorState(e.toString()));
    }
  }
}
