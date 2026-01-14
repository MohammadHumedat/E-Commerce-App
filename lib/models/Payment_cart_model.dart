class PaymentCardModel {
  PaymentCardModel({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cVV,
  });
  String id;
  String holderName;
  String cardNumber;
  String expiryDate;
  String cVV;
}

List<PaymentCardModel> dummyPaymentCardList = [
  PaymentCardModel(
    id: '1',
    holderName: 'Mohammad Hmedat',
    cardNumber: '1234 5678 9012 3456',
    expiryDate: '12/24',
    cVV: '123',
  ),
  PaymentCardModel(
    id: '2',
    holderName: 'Jane Smith',
    cardNumber: '9876 5432 1098 7654',
    expiryDate: '11/23',
    cVV: '456',
  ),
];
