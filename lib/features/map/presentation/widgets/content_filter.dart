import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/filter_container.dart';
import 'package:flutter/material.dart';

class ContentFilter extends StatefulWidget {
  const ContentFilter({super.key});

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  // TODO: cambiar variable para que no sobreescriba en todos los casos o borrar?
  bool filtroActivo = false;
  
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

          // Seccion estado del contenedor
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            child: ExpansionTileCustom(
              title: 'Estado',
              initiallyOpen: true,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButtonFilter(label: 'Operativo', selected: filtroActivo, onTap: () {
                      setState(() {
                        filtroActivo = !filtroActivo;
                        print(filtroActivo);
                      });
                    },),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomButtonFilter(label: 'En mantenimiento', selected: filtroActivo, onTap: () {
                      setState(() {
                        filtroActivo = !filtroActivo;
                      });
                    },),
                  ),
                ],
              )
            ),
          ),
          // TODO: padding con hijo ExpansionTileCustom para la seleccion de dias de recoleccion

          // TODO: padding con hijo ExpansionTileCustom para la seleccion de nivel de llenado del contenedor
        ],
      ),
    );
  }
}
