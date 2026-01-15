import 'package:flutter/material.dart';

// Define the different types of payment methods available in the app
enum PaymentType { visa, mastercard, paypal, googlePay, applePay }

extension PaymentTypeExtension on PaymentType {
  String get displayName {
    switch (this) {
      case PaymentType.visa:
        return 'Visa';
      case PaymentType.mastercard:
        return 'Mastercard';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.googlePay:
        return 'Google Pay';
      case PaymentType.applePay:
        return 'Apple Pay';
    }
  }

  // Network image URLs for payment icons
  String get iconUrl {
    switch (this) {
      case PaymentType.visa:
        return 'https://cdn-icons-png.flaticon.com/128/349/349221.png';
      case PaymentType.mastercard:
        return 'https://cdn-icons-png.flaticon.com/128/349/349228.png';
      case PaymentType.paypal:
        return 'https://cdn-icons-png.flaticon.com/128/174/174861.png';
      case PaymentType.googlePay:
        return 'https://cdn-icons-png.flaticon.com/128/6124/6124998.png';
      case PaymentType.applePay:
        return 'https://cdn-icons-png.flaticon.com/128/5977/5977576.png';
    }
  }

  // Fallback icon if network image fails to load
  IconData get fallbackIcon {
    switch (this) {
      case PaymentType.visa:
      case PaymentType.mastercard:
        return Icons.credit_card;
      case PaymentType.paypal:
        return Icons.payment;
      case PaymentType.googlePay:
        return Icons.g_mobiledata;
      case PaymentType.applePay:
        return Icons.apple;
    }
  }

  // Colors for each payment type
  List<Color> get gradientColors {
    switch (this) {
      case PaymentType.visa:
        return const [Color(0xFF1A1F71), Color(0xFF0066B2)];
      case PaymentType.mastercard:
        return const [Color(0xFFEB001B), Color(0xFFF79E1B)];
      case PaymentType.paypal:
        return const [Color(0xFF003087), Color(0xFF009CDE)];
      case PaymentType.googlePay:
        return const [Color(0xFF4285F4), Color(0xFF34A853)];
      case PaymentType.applePay:
        return const [Color(0xFF000000), Color(0xFF434343)];
    }
  }

  // Helper to check if it's a card-based payment
  bool get isCardBased =>
      this == PaymentType.visa || this == PaymentType.mastercard;

  // Helper to check if it's a digital wallet
  bool get isDigitalWallet =>
      this == PaymentType.paypal ||
      this == PaymentType.googlePay ||
      this == PaymentType.applePay;
}
