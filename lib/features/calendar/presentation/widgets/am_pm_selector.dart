import 'package:flutter/material.dart';

class AmPmSelector extends StatelessWidget {
  final bool isAm;
  final ValueChanged<bool> onChanged;
  final double height;

  const AmPmSelector({
    required this.isAm,
    required this.onChanged,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: height + 20,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _btn('AM', isAm, () => onChanged(true)),
                const SizedBox(height: 8),
                _btn('PM', !isAm, () => onChanged(false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _btn(String text, bool selected, VoidCallback onTap) {
  final radius = BorderRadius.circular(16);

  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F3EA) : Colors.white,
          borderRadius: radius,
          border: Border.all(color: const Color(0xFFDBDBDB)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.black87,
          ),
        ),
      ),
    ),
  );
}