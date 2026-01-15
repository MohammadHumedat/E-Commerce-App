import 'package:e_commerce_app/models/Payment_cart_model.dart';

class AddCardState {}

final class CardInitial extends AddCardState {}

final class CardLoading extends AddCardState {}

final class CardLoaded extends AddCardState {
  CardLoaded(this.cards, {this.wasJustAdded = false});

  final List<PaymentCardModel> cards;
  final bool wasJustAdded; // Flag to indicate if a card was just added
}

final class CardFailure extends AddCardState {
  CardFailure(this.errorMessage);
  final String errorMessage;
}
