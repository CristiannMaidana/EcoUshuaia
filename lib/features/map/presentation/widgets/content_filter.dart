import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentFilter extends StatefulWidget {
  const ContentFilter({super.key});

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  // TODO: cambiar variable para que no sobreescriba en todos los casos o borrar?
  bool filtroActivo = false;
  // TODO: cambiar por lista de vm de DB
  List<String> labels = ['Hoy', 'Mañana', 'Semana', '00:00 - 06:00', '06:00 - 12:00', '12:00 - 19:00', '19:00 - 24:00'];
  // TODO: cambiar por lista de base de datos
  List<String> categorias = ['Todos','Plastico','Papel y carton','Vidrio','Metales','Organico','Electronicos','Textiles',];

  @override
  Widget build(BuildContext context) {
    final vmResiduos = context.watch<ResiduoViewmodel>();
    
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: vmResiduos.items.map((residuo){
                  return CustomButtonFilter(label: residuo.nombre, icon: Icon(Icons.circle, size: 12, color: Colors.blue,),);
                }).toList(),
              )
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
                    child: CustomButtonFilter(label: 'Operativo'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomButtonFilter(label: 'En mantenimiento'),
                  ),
                ],
              )
            ),
          ),

          // Seccion dias de recoleccion
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            child: ExpansionTileCustom(
              title: 'Recolección',
              initiallyOpen: true,
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: labels.map((label) {
                    return CustomButtonFilter(
                      label: label,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Seccion nivel de llenado del contenedor
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            child: ExpansionTileCustom(
              title: 'Nivel de llenado',
              initiallyOpen: true,
              child: Row(
                children: [
                  Expanded(child: CustomButtonFilter(label: 'Bajo')),
                  SizedBox(width: 8,),
                  Expanded(child: CustomButtonFilter(label: 'Medio')),
                  SizedBox(width: 8,),
                  Expanded(child: CustomButtonFilter(label: 'Alto'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
