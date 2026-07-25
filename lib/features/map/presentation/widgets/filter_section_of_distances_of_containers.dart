import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/slider_custom.dart';
import 'package:flutter/material.dart';

class FilterSectionOfDistancesOfContainers extends StatelessWidget {
  final double lon;
  final double lat;
  
  const FilterSectionOfDistancesOfContainers ({
    super.key,
    required this.lon,
    required this.lat,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: add provider for the filter of the location of containers 

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
      child: ExpansionTileCustom(
        title: 'Distancia desde mi ubicación',
        initiallyOpen: true,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            SliderCustom(
              lon: lon,
              lat: lat,
              maxRadiusM: 10000,
            ),
          ]
        ),
      ),
    );
  }
}