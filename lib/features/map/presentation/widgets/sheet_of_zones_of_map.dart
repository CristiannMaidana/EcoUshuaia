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
  late ScrollController scrollControllerOfZonesSheet;

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

  Future<void> expandSheet() async {
    await draggableControllerOfZonesSheet.animateTo(
      widget.maxSheetSize, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    await draggableControllerOfZonesSheet.animateTo(
      widget.initialSheetSize, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfZonesSheet.isAttached) return false;
    return draggableControllerOfZonesSheet.size > widget.initialSheetSize;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableControllerOfZonesSheet,
      initialChildSize: widget.initialSheetSize,
      minChildSize: widget.minSheetSize,
      maxChildSize: widget.maxSheetSize,
      builder: (context, scrollControllerDefault){
        scrollControllerOfZonesSheet = scrollControllerDefault;
        return Material(
          color: Colors.white,
        );
      }
    );
  }
}