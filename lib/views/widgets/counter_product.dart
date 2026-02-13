import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:flutter/material.dart';

class ModernCounter extends StatelessWidget {

  const ModernCounter({
    super.key,
    required this.value,
    required this.onIncrease,
    required this.onDecrease,
  });
  final int value;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //DECREASE 
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (value > 1) {
                onDecrease();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.remove,
                  size: 22,
                  color: value > 1 ? Colors.black : Colors.deepOrange.shade200,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          //VALUE
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              '$value',
              key: ValueKey(value),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(width: 14),

          //  INCREASE 
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onIncrease,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.add, size: 22, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
