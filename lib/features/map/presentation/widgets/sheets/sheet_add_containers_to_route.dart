import 'package:flutter/material.dart';

class SheetAddContainersToRoute extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetAddContainersToRoute({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.70,
  });

  @override
  State<SheetAddContainersToRoute> createState() => SheetAddContainersToRouteState();
}

class SheetAddContainersToRouteState extends State<SheetAddContainersToRoute> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      
    );
  }
}