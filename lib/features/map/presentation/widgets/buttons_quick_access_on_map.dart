import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ButtonsQuickAccessOnMap extends StatelessWidget {
  final VoidCallback actionButtonZones;
  final VoidCallback actionButtonStyleMap;
  final VoidCallback actionButtonCenterCamera;

  const ButtonsQuickAccessOnMap({
    super.key,
    required this.actionButtonZones,
    required this.actionButtonStyleMap,
    required this.actionButtonCenterCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //Button texture of map
          FloatingActionButton(
            heroTag: 'fab-map-style',
            onPressed: actionButtonStyleMap,
            backgroundColor: Colors.white,
            child: Icon(Icons.map, color: camarone900, size: 30),
          ),
          const SizedBox(height: 10),
          // Button zones on map
          FloatingActionButton(
            heroTag: 'fab-add-zones',
            onPressed: actionButtonZones,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.layers_rounded,
              color: camarone900,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          // Button center camera
          FloatingActionButton(
            heroTag: 'fab-center-camera',
            onPressed: actionButtonCenterCamera,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.my_location,
              color: camarone900,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}