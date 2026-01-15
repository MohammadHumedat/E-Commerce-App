import 'package:e_commerce_app/models/Payment_cart_model.dart';
import 'package:flutter/material.dart';

class PaymentCardItem extends StatelessWidget {
  const PaymentCardItem({super.key, required this.chosenCard,  required this.onTap});
  final PaymentCardModel chosenCard;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.credit_card, color: Colors.blue, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      chosenCard.holderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  '**** **** **** ${chosenCard.cardNumber.substring(chosenCard.cardNumber.length - 4)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const Spacer(),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
