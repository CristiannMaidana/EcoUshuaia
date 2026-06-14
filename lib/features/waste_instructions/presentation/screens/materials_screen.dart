import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:flutter/material.dart';

class MaterialsScreen extends StatelessWidget{

  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        toolbarHeight: 110,
        // Text of header
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Guia rapida',
              style: Theme.of(context).textTheme.labelMedium
            ),
            const SizedBox(height: 2),
            Text('Materiales',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Seleccioná un residuo para ver cómo prepararlo y dónde llevarlo.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),      
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Section materiales frecuents select
                CardDynamic(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text('Materiales frecuentes', style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: 10,),
                      Text('Elegí un material para ver recomendaciones rápidas de separación y descarte.',
                        style: Theme.of(context).textTheme.bodyMedium,  
                      ),
                    
                    ],
                  )
                )
              ],
            ),
          ),
      ),
    );
  }
}