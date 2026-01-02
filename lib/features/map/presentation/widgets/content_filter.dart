import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/horario_recoleccion_filtros_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
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
  // TODO: cambiar variable para que no sobreescriba en todos los casos o borrar?
  bool filtroActivo = false;
  // TODO: cambiar por lista de vm de DB
  List<String> labels = ['Hoy', 'Mañana', '06:00 - 12:00', '12:00 - 18:00', '18:00 - 24:00'];

  // Cargo los items del vm
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<HorarioRecoleccionFiltrosViewModel>().initAll();
    });
  }
  
  // Helper para cargar la lista de ids desde vm
  List<int> _idsForIndex(int i) {
      final hvm = context.read<HorarioRecoleccionFiltrosViewModel>();

    // Mapea lista con ids de categoria
    List<int> idsOf(List<HorarioRecoleccionFiltros> xs) =>
        xs.map((e) => e.idCategoriaResiduos).toSet().toList();

    switch (i) {
      case 0: return idsOf(hvm.itemsDiaZona);
      case 1: return idsOf(hvm.itemsHoraMannanaZona);
      case 2: return idsOf(hvm.itemsHoraUno);
      case 3: return idsOf(hvm.itemsHoraDos);
      case 4: return idsOf(hvm.itemsHoraTres);
      default: return const [];
    }
  }
  
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
          //Padding(
            //padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            //child: ExpansionTileCustom(
              //title: 'Estado',
              //initiallyOpen: true,
              //child: Row(
                //children: [
                  //Expanded(
                    //child: CustomButtonFilter(label: 'Operativo'),
                  //),
                  //SizedBox(width: 8),
                  //Expanded(
                    //child: CustomButtonFilter(label: 'En mantenimiento'),
                  //),
                //],
              //)
            //),
          //),

          // Seccion dias de recoleccion
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            child: ExpansionTileCustom(
              title: 'Recolección',
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
                      children: List.generate(2, (i) {
                        final label = labels[i];
                        final ids   = _idsForIndex(i);
                        return CustomButtonFilter(
                          label: label,
                          onTap: widget.aplicarFiltros,
                          tipoDeBoton: 'H_$i',
                          idEntidades: ids,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.start,
                      children: List.generate(labels.length - 2, (j) {
                        final i     = j + 2;
                        final label = labels[i];
                        final ids   = _idsForIndex(i);
                        return CustomButtonFilter(
                          label: label,
                          onTap: widget.aplicarFiltros,
                          tipoDeBoton: 'H_$i',
                          idEntidades: ids,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          )
          // Seccion nivel de llenado del contenedor
          //Padding(
            //padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
            //child: ExpansionTileCustom(
              //title: 'Nivel de llenado',
              //initiallyOpen: true,
              //child: Row(
                //children: [
                  //Expanded(child: CustomButtonFilter(label: 'Bajo')),
                  //SizedBox(width: 8,),
                  //Expanded(child: CustomButtonFilter(label: 'Medio')),
                  //SizedBox(width: 8,),
                  //Expanded(child: CustomButtonFilter(label: 'Alto'))
                //],
              //),
            //),
          //),
        ],
      ),
    );
  }
}