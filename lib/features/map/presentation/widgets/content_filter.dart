import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/filter_container.dart';
import 'package:flutter/material.dart';

class ContentFilter extends StatefulWidget {
  const ContentFilter({super.key});

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: camarone100,
      child: Column(
        children: [
          // Seccion de tipo de residuos
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            child: ExpansionTileCustom(
              title: 'Tipos de residuo',
              initiallyOpen: true,
              child: FilterContainer(
                // TODO: Cambiar por lista de vm
                categorias: const [
                  'Todos','Plastico','Papel y carton','Vidrio','Metales',
                  'Organico','Electronicos','Textiles',
                ],
              ),
            ),
          ),            
          // TODO: padding con hijo ExpansionTileCustom para la seleccion de estado del contenedor

          // TODO: padding con hijo ExpansionTileCustom para la seleccion de dias de recoleccion

          // TODO: padding con hijo ExpansionTileCustom para la seleccion de nivel de llenado del contenedor
        ],
      ),
    );
  }
}
