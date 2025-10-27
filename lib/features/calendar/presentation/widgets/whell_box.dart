import 'package:flutter/material.dart';

class WheelBox extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final FixedExtentScrollController controller;
  final int itemCount;
  final double itemExtent;
  final String Function(int index) display;
  final ValueChanged<int> onSelected;

  const WheelBox({
    required this.label,
    required this.width,
    required this.height,
    required this.controller,
    required this.itemCount,
    required this.itemExtent,
    required this.display,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + 46,
      child: Column(
        children: [
          // Label
          Container(
            height: 35,
            alignment: Alignment.center,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          // Wheel
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Color(0xFFDBDBDB)),
            ),
            color: Colors.white,
            child: SizedBox(
              height: height,
              child: ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: itemExtent,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onSelected,
                perspective: 0.002,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 0 || index >= itemCount) return null;
                    return Center(
                      child: Text(
                        display(index),
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}