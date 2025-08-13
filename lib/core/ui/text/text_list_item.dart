import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class TextListItem extends StatelessWidget{
  final String texto;

  const TextListItem(this.texto);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: camarone950),
        SizedBox(width: 8),
        Text(texto, style: TextStyle(color: camarone950)),
      ]
    );
  }
}