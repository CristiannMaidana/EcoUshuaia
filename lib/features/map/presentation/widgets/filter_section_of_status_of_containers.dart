import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';

class FilterSectionOfStatusOfContainers extends StatelessWidget {
  const FilterSectionOfStatusOfContainers({super.key});

  @override
  Widget build(BuildContext context) {
    const typeOfStatusOfContainer = [
      'Disponible',
      'Casi llenos',
      'Llenos',
      'En mantenimiento',
      'Fuera de servicio',
    ];
    
    const iconsOfStatusOfContainer = <IconData>[
      Icons.check_circle_outline,
      Icons.error_outline,
      Icons.cancel_outlined,
      Icons.handyman_outlined,
      Icons.remove_circle_outline
    ];

    const colorForIcons = <Color>[
      camarone600,
      Color.fromRGBO(254, 213, 131, 1),
      Color.fromRGBO(215, 67, 77, 1),
      Color.fromRGBO(57, 165, 235, 1),
      Color.fromRGBO(93, 94, 102, 1),
    ];

    // TODO: create provider and get the list of containers filter for status of sensor
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
      child: ExpansionTileCustom(
        title: 'Disponibilidad/Estado',
        initiallyOpen: true,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(typeOfStatusOfContainer.length, (status) {
            return CustomButtonFilter(
              tipoDeBoton: 1,
              label: typeOfStatusOfContainer[status],
              icon: Icon(iconsOfStatusOfContainer[status], color: colorForIcons[status],),
            );
          }),
        ),
      ),
    );
  }
}
