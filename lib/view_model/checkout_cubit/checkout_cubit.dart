import 'package:e_commerce_app/models/Payment_cart_model.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/cart_service.dart';
import 'package:e_commerce_app/services/checkout_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutCubitInitial());

  final _checkoutService = CheckoutServiceImpl();
  final _cartService = CartServiceImp();
  final _authService = AuthServiceImpl();

  PaymentCardModel? selectedCard;

  Future<void> loadCheckoutData() async {
    emit(CheckoutLoadingState());

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        emit(CheckoutErrorState('User not authenticated'));
        return;
      }

      final cartItems = await _cartService.loadCartItems(userId);

      if (cartItems.isEmpty) {
        emit(CheckoutErrorState('Cart is empty'));
        return;
      }

      final subTotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      final numOfProduct = cartItems.fold<int>(
        0,
        (previous, element) => previous + element.quantity,
      );

      final paymentMethods = await _checkoutService.fetchPaymentMethods(userId);
      final defaultCard = paymentMethods.isNotEmpty
          ? paymentMethods.first
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
      emit(CheckoutErrorState('Failed to load checkout: ${e.toString()}'));
    }
  }

  void selectPaymentCard(PaymentCardModel card) {
    if (state is CheckoutLoadedState) {
      final currentState = state as CheckoutLoadedState;
      selectedCard = card;
      emit(currentState.copyWith(selectedCard: card));
    }
  }

  void selectAddress(LocationItemModel address) {
    if (state is CheckoutLoadedState) {
      final current = state as CheckoutLoadedState;
      emit(current.copyWith(selectedAddress: address));
    }
  }

  Future<void> confirmPayment() async {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    if (currentState.selectedCard == null) {
      emit(ConfirmPaymentFailure('Please select a payment method'));
      emit(currentState);
      return;
    }

    if (currentState.selectedAddress == null) {
      emit(ConfirmPaymentFailure('Please select a delivery address'));
      emit(currentState);
      return;
    }

    emit(ConfirmPaymentLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      // TODO: هنا يمكن إضافة:
      // 1. حفظ الطلب في Firebase
      // 2. تفريغ السلة
      // 3. إرسال إشعار

      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailure('Payment failed: ${e.toString()}'));
      emit(currentState); // إرجاع الحالة السابقة
    }
  }

  void retryPayment() {
    confirmPayment();
  }
}
