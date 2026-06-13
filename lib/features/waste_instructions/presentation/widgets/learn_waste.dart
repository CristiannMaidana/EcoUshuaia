import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:flutter/material.dart';

class LearnWaste extends StatelessWidget{
  const LearnWaste({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(width: 1.5, color: Colors.grey[400]!),
      ),
      //Contents
      child: Column(
        children: [
          // Text
          Container(
            decoration: BoxDecoration(
              color: camarone100,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(width: 1.5, color: Colors.grey[400]!),    
            ),
            child: Column(
              children: [
                Text('Aprendé a reciclar mejor'),
                Text('Entrá a una guía simple para ver cómo preparar cada residuo, qué evitar y cuándo hace falta un punto especial.')
              ],
            ),
          ),
          // Card with actions
          Row(
            children: [
              
            ],
          )
        ],
      ),
    );
  }
}