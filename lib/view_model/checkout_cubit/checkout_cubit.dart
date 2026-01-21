import 'package:e_commerce_app/models/Payment_cart_model.dart';
import 'package:e_commerce_app/models/location_item_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutCubitInitial());
  PaymentCardModel? selectedCard;
  void loadCheckoutData() {
    emit(CheckoutLoadingState());
    try {
      final cartItems = addToCartItems;

      final subTotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.product.price * item.quantity,
      );

      final numOfProduct = cartItems.fold<int>(
        0,
        (previous, element) => previous + element.quantity,
      );

      final defaultCard = dummyPaymentCardList.isNotEmpty
          ? dummyPaymentCardList.first
          : null;

      final defaultAddress = dummyLocationItems.isNotEmpty
          ? dummyLocationItems.first
          : null;

      emit(
        CheckoutLoadedState(
          cartItems: cartItems,
          totalPrice: subTotal + 10,
          numOfProduct: numOfProduct,
          selectedCard: defaultCard,
          selectedAddress: defaultAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutErrorState(e.toString()));
    }
  }

  void selectPaymentCard(PaymentCardModel card) {
    if (state is CheckoutLoadedState) {
      final currentState = state as CheckoutLoadedState;
      emit(currentState.copyWith(selectedCard: card));
    }
  }

  void confirmPayment() async {
    emit(ConfirmPaymentLoading());
    await Future.delayed(const Duration(seconds: 2));

    emit(ConfirmPaymentSuccess());
  }

  void selectAddress(LocationItemModel address) {
    if (state is CheckoutLoadedState) {
      final current = state as CheckoutLoadedState;
      emit(current.copyWith(selectedAddress: address));
    }
  }
}
