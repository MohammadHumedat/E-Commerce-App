import 'package:e_commerce_app/models/Payment_cart_model.dart';


import 'package:e_commerce_app/view_model/payment_card/card_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(CardInitial());

  Future<void> addCard(
    int id,
    String holderName,
    String cardNumber,
    String expiryDate,
    String cVV,
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
      );

      dummyPaymentCardList.add(newCard);

      emit(CardSuccess());
    } catch (e) {
      emit(CardFailure('Failed to add card'));
    }
  }
}
