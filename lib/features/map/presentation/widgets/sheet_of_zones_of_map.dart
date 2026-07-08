import 'package:flutter/material.dart';

class SheetOfZonesOfMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetOfZonesOfMap({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
  });

  @override
  State<SheetOfZonesOfMap> createState() => SheetOfZonesOfMapState();
}

class SheetOfZonesOfMapState extends State<SheetOfZonesOfMap> {
  late final DraggableScrollableController draggableControllerOfZonesSheet;
  late final ScrollController scrollControllerOfZonesSheet;

  @override
  void initState() {
    super.initState();
    draggableControllerOfZonesSheet = DraggableScrollableController();
  }

  @override
  void dispose() {
    draggableControllerOfZonesSheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableControllerOfZonesSheet,
      builder: (context, scrollControllerDefault){
        scrollControllerOfZonesSheet = scrollControllerDefault;
        return Material(

        );
      }
    );
  }
}