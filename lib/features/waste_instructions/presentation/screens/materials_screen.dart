import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/data/materials_data.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/detail_material_card.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/details_material.dart';
import 'package:flutter/material.dart';

class MaterialsScreen extends StatelessWidget {
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
            Text('Guia rapida', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 2),
            Text(
              'Materiales',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Seleccioná un residuo para ver cómo prepararlo y dónde llevarlo.',
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
                    Text(
                      'Materiales frecuentes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Elegí un material para ver recomendaciones rápidas de separación y descarte.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    // List of materials
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth < 360
                            ? 1
                            : constraints.maxWidth < 720
                            ? 2
                            : 4;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: wasteMaterials.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 150,
                              ),
                          itemBuilder: (context, index) {
                            final material = wasteMaterials[index];

                            return DetailsMaterial(
                              iconText: material.iconText,
                              iconBackgroundColor: material.iconBackgroundColor,
                              tag: material.tag,
                              title: material.title,
                              description: material.description,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Card of instruction of material
              DetailMaterialCard(
                iconText: 'P',
                iconBackgroundColor: const Color(0xFFEAB308),
                title: 'Plástico',
                description: 'Envases y objetos reciclables de uso cotidiano.',
                tag: 'Frecuente',
                chips: const ['Botellas', 'Envases', 'Recipientes'],
                tips: const [
                  DetailMaterialTip(
                    mark: '✓',
                    title: 'Cómo prepararlo',
                    description:
                        'Lavar y secar antes de reciclar para evitar contaminación del resto del material.',
                  ),

                  DetailMaterialTip(
                    mark: '!',
                    title: 'Qué evitar',
                    description:
                        'No incluir plásticos con restos de comida, aceites o químicos.',
                  ),

                  DetailMaterialTip(
                    mark: '⌖',
                    title: 'Dónde llevarlo',
                    description:
                        'Podés usar contenedores comunes de reciclaje cercanos o puntos marcados en el mapa.',
                  ),
                ],
                onBackPressed: () {},
                onViewContainersPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
