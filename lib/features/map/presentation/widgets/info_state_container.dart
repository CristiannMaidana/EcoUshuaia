import 'package:flutter/material.dart';

class InfoStateContainer extends StatelessWidget{
  final String titulo;
  final String descripcion;

  const InfoStateContainer({
    super.key, 
    required this.titulo,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}