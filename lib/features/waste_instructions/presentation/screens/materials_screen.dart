import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/categoria_residuos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/detail_material_card.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/details_material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CategoriaResiduosViewmodel(
            ctx.read<CategoriaResiduosRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ResiduoViewmodel(ctx.read<ResiduoRepository>())..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final residuosVm = context.watch<ResiduoViewmodel>();
          final categoriasVm = context.watch<CategoriaResiduosViewmodel>();

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 110,
              // Text of header
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Guia rapida',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Materiales',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                          if (residuosVm.loading || categoriasVm.loading)
                            const Center(child: CircularProgressIndicator())
                          else if (residuosVm.error != null)
                            Text(residuosVm.error!)
                          else if (categoriasVm.error != null)
                            Text(categoriasVm.error!)
                          else
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount =
                                    constraints.maxWidth < 360
                                    ? 1
                                    : constraints.maxWidth < 720
                                    ? 2
                                    : 4;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: residuosVm.items.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: 150,
                                      ),
                                  itemBuilder: (context, index) {
                                    final residuo = residuosVm.items[index];

                                    return DetailsMaterial(
                                      iconText: _iconTextFromName(
                                        residuo.nombre,
                                      ),
                                      iconBackgroundColor: _colorFromHex(
                                        residuo.colorHex,
                                      ),
                                      tag:
                                          categoriasVm.labelFor(
                                            residuo.idCategoriaResiduo,
                                          ) ??
                                          '',
                                      title: residuo.nombre,
                                      description:
                                          residuo.descripcion ??
                                          residuo.instruccionReciclado ??
                                          '',
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
                      description:
                          'Envases y objetos reciclables de uso cotidiano.',
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
        },
      ),
    );
  }
}

Color _colorFromHex(String hex) {
  var value = hex.replaceAll('#', '');
  if (value.length == 6) value = 'FF$value';
  return Color(int.parse(value, radix: 16));
}

String _iconTextFromName(String name) {
  final words = name
      .split(RegExp(r'\s+'))
      .where(
        (word) =>
            word.isNotEmpty &&
            word.toLowerCase() != 'y' &&
            word.toLowerCase() != 'de' &&
            word.toLowerCase() != 'del',
      )
      .toList();

  if (words.isEmpty) return '?';
  if (words.length == 1) return words.first.substring(0, 1).toUpperCase();

  return '${words[0][0]}${words[1][0]}'.toUpperCase();
}
