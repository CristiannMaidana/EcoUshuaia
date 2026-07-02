import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/categoria_residuos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/materials_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/details_material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrequentMaterials extends StatelessWidget {
  const FrequentMaterials({super.key});

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
          final previewMaterials = residuosVm.items.take(5).toList();

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
                          MaterialPageRoute(
                            builder: (_) => const MaterialsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Ver todos', 
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: camarone700
                          )
                        ),
                    ),
                  ],
                ),
                //Option of materials
                const SizedBox(height: 16),
                if (residuosVm.loading || categoriasVm.loading)
                  const Center(child: CircularProgressIndicator())
                else if (residuosVm.error != null)
                  Text(residuosVm.error!)
                else if (categoriasVm.error != null)
                  Text(categoriasVm.error!)
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: previewMaterials.map((residuo) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 180,
                            child: DetailsMaterial(
                              iconText: _iconTextFromName(residuo.nombre),
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
