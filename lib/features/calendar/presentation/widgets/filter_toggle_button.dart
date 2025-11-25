import 'package:flutter/material.dart';

class FilterToggleButton extends StatelessWidget {
  final String categoria;
  final Color dotColor;
  final bool selected;
  final VoidCallback onPressed;

  const FilterToggleButton({
    required this.categoria,
    required this.dotColor,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.grey[300];
    final side = BorderSide(color: selected ? Colors.black38 : Colors.black26, width: 1);
    final textStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: selected ? Colors.black : Colors.black54, fontWeight: FontWeight.w500);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.black,
        side: side,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26, width: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(categoria, style: textStyle),
        ],
      ),
    );
  }
}
