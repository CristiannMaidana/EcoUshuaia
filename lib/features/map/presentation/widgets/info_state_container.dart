import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoStateContainer extends StatelessWidget{
  final String titulo;
  final String descripcion;
  final IconData icon;

  const InfoStateContainer({
    super.key, 
    required this.titulo,
    required this.descripcion,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: .3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: camarone600),
              SizedBox(width: 5),
              Text(titulo, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          SizedBox(height: 8),
          Text(descripcion, style: Theme.of(context).textTheme.labelMedium),
        ],
      )
    );
  }
}