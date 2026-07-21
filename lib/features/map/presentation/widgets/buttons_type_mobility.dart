import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ButtonsTypeMobility extends StatelessWidget {
  final int selectedRouteProfile;
  final VoidCallback onCarPressed;
  final VoidCallback onBikePressed;
  final VoidCallback onWalkPressed;

  const ButtonsTypeMobility({
    super.key,
    required this.selectedRouteProfile,
    required this.onCarPressed,
    required this.onBikePressed,
    required this.onWalkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(width: 1, color: Colors.grey.shade300),
          color: Color.fromRGBO(249, 249, 249, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: onCarPressed,
              icon: const Icon(Icons.directions_car, size: 30,),
              color: selectedRouteProfile == 0
                  ? camarone600
                  : Colors.grey.shade700,
            ),
            Container(width: 1, height: 30, color: Colors.grey),
            IconButton(
              onPressed: onBikePressed,
              icon: const Icon(Icons.directions_bike, size: 30),
              color: selectedRouteProfile == 1
                  ? camarone600
                  : Colors.grey.shade700,
            ),
            Container(width: 1, height: 30, color: Colors.grey),
            IconButton(
              onPressed: onWalkPressed,
              icon: const Icon(Icons.directions_walk, size: 30),
              color: selectedRouteProfile == 2
                  ? camarone600
                  : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
