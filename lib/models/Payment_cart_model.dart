import 'package:e_commerce_app/Constants/payments_type.dart';

class PaymentCardModel {
  PaymentCardModel({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cVV,
    required this.paymentType,
  });
  factory PaymentCardModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return PaymentCardModel(
      id: documentId,
      holderName: map['holderName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cVV: map['cVV'] ?? '',
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == map['paymentType'],
        orElse: () => PaymentType.visa,
      ),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'holderName': holderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cVV': cVV,
      'paymentType': paymentType.name,
    };
  }

  String id;
  String holderName;
  String cardNumber; // For cards, email for PayPal
  String expiryDate;
  String cVV;
  PaymentType paymentType;

  // Helper to check if it's a card-based payment
  bool get isCardBased =>
      paymentType == PaymentType.visa || paymentType == PaymentType.mastercard;

  // Helper to check if it's a digital wallet
  bool get isDigitalWallet =>
      paymentType == PaymentType.paypal ||
      paymentType == PaymentType.googlePay ||
      paymentType == PaymentType.applePay;

  PaymentCardModel copyWith({
    // Add copyWith method for easy updates
    String? id,
    String? holderName,
    String? cardNumber,
    String? expiryDate,
    String? cVV,
    PaymentType? paymentType,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cVV: cVV ?? this.cVV,
      paymentType: paymentType ?? this.paymentType,
    );
  }
}

List<PaymentCardModel> dummyPaymentCardList = [
  PaymentCardModel(
    id: '1',
    holderName: 'John Doe',
    cardNumber: '4532123456789012',
    expiryDate: '12/25',
    cVV: '123',
    paymentType: PaymentType.visa,
  ),
  PaymentCardModel(
    id: '2',
    holderName: 'Jane Smith',
    cardNumber: '5425123456789012',
    expiryDate: '06/26',
    cVV: '456',
    paymentType: PaymentType.mastercard,
  ),
];
