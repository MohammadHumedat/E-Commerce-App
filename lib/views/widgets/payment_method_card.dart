import 'package:e_commerce_app/Constants/app_routes.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on theme for performance and consistency
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = Colors.blue.withOpacity(isDarkMode ? 0.5 : 0.3);
    final textColor = isDarkMode ? Colors.white70 : Colors.grey[700];
    final iconColor = isDarkMode ? Colors.white38 : Colors.grey[500];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1.5),
        ),

        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.paymentMethod);
          },
          // Modern touch feedback
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Icon
                Icon(
                  Icons.add_card_rounded,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),

                // Main Text
                Text(
                  'Add Payment Method',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
