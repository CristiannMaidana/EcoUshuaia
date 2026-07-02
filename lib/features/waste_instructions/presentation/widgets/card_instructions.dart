import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CardInstructions extends StatelessWidget {
  const CardInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: camarone100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: .3, color: camarone300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aprendé a reciclar mejor',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Entrá a una guía simple para ver cómo preparar cada residuo, qué evitar y cuándo hace falta un punto especial.',
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Image.asset(
            'assets/images/recycle.png',
            width: 160,
            height: 160,
          ),
        ],
      )
    );
  }
}