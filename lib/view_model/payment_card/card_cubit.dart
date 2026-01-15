import 'package:e_commerce_app/Constants/payments_type.dart';
import 'package:e_commerce_app/models/Payment_cart_model.dart';

import 'package:e_commerce_app/view_model/payment_card/card_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(CardInitial());

  Future<void> addCard(
    String holderName,
    String cardNumber,
    String expiryDate,
    String cVV,
    PaymentType paymentType,
  ) async {
    emit(CardLoading());

    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final newCard = PaymentCardModel(
        id: DateTime.now().toIso8601String(),
        holderName: holderName,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cVV: cVV,
        paymentType: paymentType,
      );

      dummyPaymentCardList.add(newCard);

      emit(
        CardLoaded(
          List<PaymentCardModel>.from(dummyPaymentCardList),
          wasJustAdded: true,
        ),
      );
    } catch (e) {
      emit(CardFailure('Failed to add payment method'));
    }
  }

  Future<void> loadCards() async {
    emit(CardLoading());

    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      emit(
        CardLoaded(
          List<PaymentCardModel>.from(dummyPaymentCardList),
          wasJustAdded: false,
        ),
      );
    } catch (e) {
      emit(CardFailure('Failed to load payment methods'));
    }
  }

  // Remove a payment method
  Future<void> removeCard(String cardId) async {
    emit(CardLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      dummyPaymentCardList.removeWhere((card) => card.id == cardId);

      emit(
        CardLoaded(
          List<PaymentCardModel>.from(dummyPaymentCardList),
          wasJustAdded: false,
        ),
      );
    } catch (e) {
      emit(CardFailure('Failed to remove payment method'));
    }
  }
}
