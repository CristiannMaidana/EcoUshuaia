import 'package:flutter/material.dart';

class SheetAddress extends StatefulWidget {
  const SheetAddress({
    super.key,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.9,
  });

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  @override
  State<SheetAddress> createState() => _SheetAddressState();
}

class _SheetAddressState extends State<SheetAddress> {
  late final DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DraggableScrollableSheet(
          controller: _draggableController,
          initialChildSize: widget.initialChildSize,
          minChildSize: widget.minChildSize,
          maxChildSize: widget.maxChildSize,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(color: Colors.grey.shade500),
                ),
                child: ListView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Column(
                      children: [
                        //Barra de arrastre
                        Container(
                          width: 70,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Contenido del sheet 
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
