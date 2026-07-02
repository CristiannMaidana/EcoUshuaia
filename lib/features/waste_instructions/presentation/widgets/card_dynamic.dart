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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(width: .3, color: Colors.grey[400]!),
      ),
      child: widget,
    );
  }
}