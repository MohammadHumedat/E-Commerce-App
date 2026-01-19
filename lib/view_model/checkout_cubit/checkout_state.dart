part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutCubitInitial extends CheckoutState {}

final class CheckoutLoadingState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {
  final List<AddToCartModel> cartItems;
  final double totalPrice;
  final int numOfProduct;
  final PaymentCardModel? selectedCard;

  CheckoutLoadedState({
    required this.cartItems,
    required this.totalPrice,
    required this.numOfProduct,
    required this.selectedCard,
  });

  CheckoutLoadedState copyWith({
    List<AddToCartModel>? cartItems,
    double? totalPrice,
    int? numOfProduct,
    PaymentCardModel? selectedCard,
  }) {
    return CheckoutLoadedState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      numOfProduct: numOfProduct ?? this.numOfProduct,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}

final class CheckoutErrorState extends CheckoutState {
  CheckoutErrorState(this.message);
  final String message;
}

final class ConfirmPaymentLoading extends CheckoutState {}

final class ConfirmPaymentSuccess extends CheckoutState {}

final class ConfirmPaymentFailure extends CheckoutState {
  ConfirmPaymentFailure(this.message);
  final String message;
}
