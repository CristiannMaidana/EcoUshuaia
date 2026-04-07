import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget{
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  
  const CircleIcon({
    super.key, 
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[400]!, width: 1),
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color)),
    );
  }
}
