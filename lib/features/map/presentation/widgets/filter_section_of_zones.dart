import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/custom_button_filter.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';

class FilterSectionOfZones extends StatelessWidget {
  const FilterSectionOfZones({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const listOfZones = <String>['Zona 1', 'Zona 2', 'Zona 3', 'Zona 4', 'Zona 5', 'Zona 6'];

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
      child: ExpansionTileCustom(
        title: 'Zonas',
        initiallyOpen: true,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(listOfZones.length, (status) {
            return CustomButtonFilter(
              tipoDeBoton: 1,
              label: listOfZones[status],
              icon: Icon(Icons.layers_outlined, color: camarone600),
            );
          }),
        ),
      ),
    );
  }
}