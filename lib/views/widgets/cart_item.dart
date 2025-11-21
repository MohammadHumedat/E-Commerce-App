import 'package:e_commerce_app/views/widgets/counter_product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

class CartItem extends StatelessWidget {
  final AddToCartModel item;
  final Function(int)? onQuantityChanged;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.item,
    this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset:  Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- Product Image ----------------
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imgURL,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // ---------------- Product Info ----------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${item.product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Size: ${item.size.name}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ---------------- Quantity + Remove ----------------
          Column(
            children: [
              ModernCounter(
                initialValue: item.quantity,
                onChanged: onQuantityChanged,
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
