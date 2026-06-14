import 'package:eco_ushuaia/features/waste_instructions/presentation/data/materials_data.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/materials_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/details_material.dart';
import 'package:flutter/material.dart';

class FrequentMaterials extends StatelessWidget {
  const FrequentMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    final previewMaterials = wasteMaterials.take(3).toList();

    return CardDynamic(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Materiales frecuentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Accesos rápidos a los residuos más comunes.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MaterialsScreen()),
                  );
                },
                child: Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preview materials
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: previewMaterials.map((material) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 250,
                    child: DetailsMaterial(
                      iconText: material.iconText,
                      iconBackgroundColor: material.iconBackgroundColor,
                      tag: material.tag,
                      title: material.title,
                      description: material.description,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MaterialsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
