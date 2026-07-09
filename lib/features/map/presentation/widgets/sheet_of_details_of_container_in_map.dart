import 'package:flutter/material.dart';

class SheetOfDetailsOfContainerInMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  
  const SheetOfDetailsOfContainerInMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
  });

  @override
  State<SheetOfDetailsOfContainerInMap> createState() => SheetOfDetailsOfContainerInMapState();
}

class SheetOfDetailsOfContainerInMapState extends State<SheetOfDetailsOfContainerInMap> {
  late final DraggableScrollableController draggableControllerOfDetailsContainerSheet;

  @override
  Widget build (BuildContext context) {
    return Stack(

    );
  }
}