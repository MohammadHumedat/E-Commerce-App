import 'package:flutter/material.dart';

class CheckoutHeadline extends StatelessWidget {
  const CheckoutHeadline({
    super.key,
    this.onTap,
    this.productNumbers,
    required this.title,
  });

  final VoidCallback? onTap;
  final int? productNumbers;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Determine if we should show a specific action button (like Edit/Change)
    final bool hasAction = onTap != null;

    final String countText = productNumbers != null
        ? '($productNumbers ${productNumbers! == 1 ? 'item' : 'items'})'
        : '';

    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: hasAction ? 8.0 : 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Title and optional Item Count
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (countText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    countText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          // Right side: Optional Action Button
          if (hasAction)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    title == 'Address' ? 'Change' : 'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 20, color: primaryColor),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
