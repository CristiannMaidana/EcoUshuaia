import 'package:flutter/material.dart';

class SheetOfZonesOfMap extends StatefulWidget {
  const SheetOfZonesOfMap({
    super.key
  });

  @override
  State<SheetOfZonesOfMap> createState() => SheetOfZonesOfMapState();
}

class SheetOfZonesOfMapState extends State<SheetOfZonesOfMap> {
  late final DraggableScrollableController draggableControllerOfZonesSheet;
  late final ScrollController scrollControllerOfZonesSheet;

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