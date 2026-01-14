class AddCardState {}

final class CardInitial extends AddCardState {}

final class CardLoading extends AddCardState {}

final class CardSuccess extends AddCardState {}

final class CardFailure extends AddCardState {
  CardFailure(this.errorMessage);
  final String errorMessage;
}
