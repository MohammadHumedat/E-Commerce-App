import 'package:flutter/material.dart';

class ModernCounter extends StatefulWidget {
  final int initialValue;
  final Function(int)? onChanged;

  const ModernCounter({super.key, this.initialValue = 1, this.onChanged});

  @override
  State<ModernCounter> createState() => _ModernCounterState();
}

class _ModernCounterState extends State<ModernCounter> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void increase() {
    setState(() => value++);
    widget.onChanged?.call(value);
  }

  void decrease() {
    if (value > 1) {
      setState(() => value--);
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------- MINUS BUTTON ----------------
          GestureDetector(
            onTap: decrease,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.remove, size: 22),
            ),
          ),

          const SizedBox(width: 14),

          // ---------------- VALUE ----------------
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

          // ---------------- PLUS BUTTON ----------------
          GestureDetector(
            onTap: increase,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add, size: 22, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
