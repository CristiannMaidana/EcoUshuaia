import 'dart:async';

import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:flutter/material.dart';

class LearnWaste extends StatelessWidget{
  final FutureOr<void> Function()? goMaterials;

  const LearnWaste({
    super.key,
    this.goMaterials,
  });

  @override
  Widget build(BuildContext context) {
    return CardDynamic(
      widget: Column(
        children: [
          // Text
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: camarone100,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(width: 1.5, color: Colors.grey[400]!),    
            ),
            child: Column(
              children: [
                Text('Aprendé a reciclar mejor', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10,),
                Text('Entrá a una guía simple para ver cómo preparar cada residuo, qué  evitar y cuándo hace falta un punto especial.', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: 10,),
          // Card with actions
          CardTouch(
            title: 'Como separar', 
            infoText: 'Consejos generales y errores comunes.', 
            width: 400,
            icon: Icons.checklist_rounded,
            iconBackgroundColor: const Color(0xFFE5F5ED),
            iconColor: const Color(0xFF237655),
          ),              
          CardTouch(
            title: 'Ver materiales', 
            infoText: 'Plástico, vidrio, papel y más.', 
            width: 400,
            icon: Icons.category_rounded,
            iconBackgroundColor: const Color(0xFFE5F5ED),
            iconColor: const Color(0xFF237655),
            onTap: () async {
              await goMaterials?.call();
            },
          ),
          CardTouch(
            title: 'Residuos especiales', 
            infoText: 'Electrónicos, peligrosos y puntos especiales.', 
            width: 400,
            icon: Icons.error_outline_rounded,
            iconBackgroundColor: const Color(0xFFE5F5ED),
            iconColor: const Color(0xFF237655),
          ),
        ],
      ),
    );
  }
}
