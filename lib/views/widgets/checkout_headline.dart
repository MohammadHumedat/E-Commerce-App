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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          // Title and product count
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (productNumbers != null)
              Text(
                '($productNumbers items)',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              'Edit',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
