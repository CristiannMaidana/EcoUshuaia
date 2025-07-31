import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class listInstrucciones extends StatelessWidget{
  final String texto;

  const listInstrucciones(this.texto);

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