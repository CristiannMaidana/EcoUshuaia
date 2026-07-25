import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/horario_recoleccion_filtros_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/filter_section_of_status_of_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentFilter extends StatefulWidget {
  final VoidCallback aplicarFiltros;

  const ContentFilter({
    super.key,
    required this.aplicarFiltros,
  });

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  List<String> labelsDate = ['Hoy', 'Mañana', 'Esta semana'];
  List<String> labelsTime = ['00:00 - 06:00', '06:00 - 12:00', '12:00 - 18:00', '18:00 - 24:00'];
  List<String> labelsGenericsFilter = ['Favoritos', 'Cercanos', 'Disponibles'];

  // Helper para cargar la lista de ids desde vm
  List<int> _idsForIndexDate(int i) {
    final hvm = context.read<HorarioRecoleccionFiltrosViewModel>();

    // Mapea lista con ids de categoria
    List<int> idsOf(List<HorarioRecoleccionFiltros> xs) =>
        xs.map((e) => e.idCategoriaResiduos).toSet().toList();

    switch (i) {
      case 0: return idsOf(hvm.itemsDiaZona);
      case 1: return idsOf(hvm.itemsHoraMannanaZona);
      //case 2: TODO: no existe carga de datos para la semana ni logica en db
      default: return const [];
    }
  }
  
  List<int> _idsForIndexTime(int i) {
    final hvm = context.read<HorarioRecoleccionFiltrosViewModel>();

    // Mapea lista con ids de categoria
    List<int> idsOf(List<HorarioRecoleccionFiltros> xs) =>
        xs.map((e) => e.idCategoriaResiduos).toSet().toList();

    switch (i) {
      //case 0: TODO: no existe carga de datos para franja 00-06
      case 1: return idsOf(hvm.itemsHoraUno);
      case 2: return idsOf(hvm.itemsHoraDos);
      case 3: return idsOf(hvm.itemsHoraTres);
      default: return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final vmResiduos = context.watch<ResiduoViewmodel>();
    
    return Column(
      children: [
        // Seccion de filtros generales
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
          child: ExpansionTileCustom(
            title: 'Accesos rapidos',
            initiallyOpen: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: labelsGenericsFilter.map((label) => CustomButtonFilter(
                label: label, 
                onTap: widget.aplicarFiltros, 
                tipoDeBoton: 'G_$label',
                //TODO: change for the correct ids of type of filter
                idEntidades: List.generate(3, (index) => index)
              )).toList(),
            )
          ),
        ),

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
                final List<int> id = [];
                id.add(residuo.idResiduo);
                return CustomButtonFilter(
                  tipoDeBoton: 1,
                  label: residuo.nombre, 
                  icon: Icon(Icons.circle, size: 12, color: residuo.colorHex.toColor(),),
                  onTap: widget.aplicarFiltros,
                  idEntidades: id,
                );
              }).toList(),
            )
          ),
        ),

        // Seccion estado del contenedor
        FilterSectionOfStatusOfContainers(),

        // Seccion dias de recoleccion
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
          child: ExpansionTileCustom(
            title: 'Horarios de recolección',
            initiallyOpen: true,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boton hoy y mañana
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    children: List.generate(labelsDate.length, (i) {
                      final ids   = _idsForIndexDate(i);
                      return CustomButtonFilter(
                        label: labelsDate[i],
                        onTap: widget.aplicarFiltros,
                        tipoDeBoton: 'H_$i',
                        idEntidades: ids,
                        icon: Icon(Icons.calendar_month, color: camarone600,),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // Botones franjas horarias
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    children: List.generate(labelsTime.length, (filterIndex) {
                      final ids = _idsForIndexTime(filterIndex);
                      return CustomButtonFilter(
                        label: labelsTime[filterIndex],
                        onTap: widget.aplicarFiltros,
                        tipoDeBoton: 'H_$filterIndex',
                        idEntidades: ids,
                        icon: Icon(Icons.timer_outlined, color: camarone600,),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
