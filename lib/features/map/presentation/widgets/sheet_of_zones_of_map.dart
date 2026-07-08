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
    draggableControllerOfZonesSheet = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    draggableControllerOfZonesSheet.removeListener(_onSheetChanged);
    draggableControllerOfZonesSheet.dispose();
    super.dispose();
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;
    
    await draggableControllerOfZonesSheet.animateTo(
      widget.maxSheetSize, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;

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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Functionality for close the sheet if is expand and touch out of the sheet.
        if (isExpandedSheet())
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: collapseSheet,
            child: const SizedBox.expand(),
          ),

        // -Sheet of zones-
        // Handle of the sheet settings
        DraggableScrollableSheet(
          controller: draggableControllerOfZonesSheet,
          initialChildSize: widget.initialSheetSize,
          minChildSize: widget.minSheetSize,
          maxChildSize: widget.maxSheetSize,
          builder: (context, scrollControllerDefault) {
            scrollControllerOfZonesSheet = scrollControllerDefault;
            // Style of sheet for view
            return SafeArea(
              top: false,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: ClipRRect(),
              ),
            );
          },
        ),
      ],
    );
  }
}
