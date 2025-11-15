import 'package:flutter/material.dart';

class CounterProduct extends StatelessWidget {
  const CounterProduct({
    super.key,
    required this.value,
    required this.cubit,
    required this.productId,
  });

  final int value;
  final dynamic cubit;
  final int productId;

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = value > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(
            icon: Icons.remove,
            onPressed: canDecrement
                ? () => cubit.decrementQuantity(productId)
                : null,
            isEnabled: canDecrement,
          ),

          Container(
            constraints: const BoxConstraints(minWidth: 40),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          _CounterButton(
            icon: Icons.add,
            onPressed: () => cubit.incrementQuantity(productId),
            isEnabled: true,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.isEnabled,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),

        splashColor: Colors.black.withOpacity(0.1),
        highlightColor: Colors.black.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled ? Colors.black87 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
