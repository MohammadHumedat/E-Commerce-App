import 'package:e_commerce_app/Constants/payments_type.dart';
import 'package:flutter/material.dart';

/// Reusable widget for displaying payment type icons from network
class PaymentIconWidget extends StatelessWidget {
  final PaymentType paymentType;
  final double size;
  final Color? color;

  const PaymentIconWidget({
    super.key,
    required this.paymentType,
    this.size = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      paymentType.iconUrl,
      width: size,
      height: size,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to Material icon if network image fails
        return Icon(
          paymentType.fallbackIcon,
          size: size,
          color: color ?? Colors.white,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        // Show loading indicator while image is downloading
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}