import 'package:e_commerce_app/Constants/payments_type.dart';
import 'package:e_commerce_app/models/Payment_cart_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/checkout_service.dart';
import 'package:e_commerce_app/view_model/payment_card/card_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(CardInitial());

  final _paymentService = CheckoutServiceImpl();
  final _authService = AuthServiceImpl();

  // add new payment method
  Future<void> addCard(
    String holderName,
    String cardNumber,
    String expiryDate,
    String cVV,
    PaymentType paymentType,
  ) async {
    emit(CardLoading());

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        // check authentication
        emit(CardFailure('User not authenticated'));
        return;
      }

      // card instance
      final newCard = PaymentCardModel(
        id: '', // auto generated form firebase
        holderName: holderName,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cVV: cVV,
        paymentType: paymentType,
      );

      // add the new card into firebase
      await _paymentService.addPaymentMethod(userId, newCard);

      // re-fetch all payment methods
      final paymentMethods = await _paymentService.fetchPaymentMethods(userId);

      emit(CardLoaded(paymentMethods, wasJustAdded: true));
    } catch (e) {
      emit(CardFailure('Failed to add payment method: ${e.toString()}'));
    }
  }

  Future<void> loadCards() async {
    emit(CardLoading());

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        emit(CardFailure('User not authenticated'));
        return;
      }

      final paymentMethods = await _paymentService.fetchPaymentMethods(userId);

      emit(CardLoaded(paymentMethods, wasJustAdded: false));
    } catch (e) {
      emit(CardFailure('Failed to load payment methods: ${e.toString()}'));
    }
  }

  // delete payment method
  Future<void> removeCard(String cardId) async {
    final currentState = state;
    if (currentState is! CardLoaded) return;

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      // Optimistic Update 
      final updatedCards = currentState.cards
          .where((card) => card.id != cardId)
          .toList();

      emit(CardLoaded(updatedCards, wasJustAdded: false));

      
      await _paymentService.removePaymentMethod(userId, cardId);
    } catch (e) {
      
      await loadCards();
      emit(CardFailure('Failed to remove payment method: ${e.toString()}'));
    }
  }

  // update payment method
  Future<void> updateCard(PaymentCardModel updatedCard) async {
    final currentState = state;
    if (currentState is! CardLoaded) return;

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      // Optimistic Update
      final updatedCards = currentState.cards.map((card) {
        if (card.id == updatedCard.id) return updatedCard;
        return card;
      }).toList();

      emit(CardLoaded(updatedCards, wasJustAdded: false));

      // update then on Firebase
      await _paymentService.updatePaymentMethod(userId, updatedCard);
    } catch (e) {
      await loadCards();
      emit(CardFailure('Failed to update payment method: ${e.toString()}'));
    }
  }
}
