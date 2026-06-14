import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/detail_material_card.dart';
import 'package:flutter/material.dart';

class InfoReciclyScreen extends StatelessWidget{

  const InfoReciclyScreen({super.key});

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
            Text('Guia rapida', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 2),
            Text(
              'Como separar',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Recomendaciones simples para preparar bien el residuo antes de reciclar.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
             DetailMaterialCard(
              title: 'Consejos generales',
              description: 'Una vista de entrada para usuarios que todavía no saben bien cómo separar.',
              tag: 'Frecuente',
              chips: const ['Lavar', 'Secar', 'Separar', 'No mezclar'],
              tips: const [
                DetailMaterialTip(
                  mark: '1',
                  title: 'Vaciar antes de reciclar',
                  description:
                      'No dejar restos de comida o líquidos dentro del residuo.',
                ),
    
                DetailMaterialTip(
                  mark: '2',
                  title: 'Lavar y secar',
                  description:
                      'Un residuo limpio evita contaminar al resto del material reciclable.',
                ),
    
                DetailMaterialTip(
                  mark: '3',
                  title: 'No mezclar especiales',
                  description:
                      'Electrónicos, peligrosos o sanitarios deben ir a puntos específicos.',
                ),
              ],
              onBackPressed: () {},
              onViewContainersPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}