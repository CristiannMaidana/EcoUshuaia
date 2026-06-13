import 'package:flutter/material.dart';

class CardDynamic extends StatelessWidget{
  final Widget widget;

  const CardDynamic({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(width: 1.5, color: Colors.grey[400]!),
      ),
      child: widget,
    );
  }
}