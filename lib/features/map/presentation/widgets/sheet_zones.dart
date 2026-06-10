import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class SheetZones extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const SheetZones({
    super.key,
    this.initialChildSize = 0.0,
    this.minChildSize = 0.0,
    this.maxChildSize = 0.45,
  });

  @override
  State<SheetZones> createState() => SheetZonesState();
}

class SheetZonesState extends State<SheetZones> {
  late final DraggableScrollableController _controller;

  ScrollPhysics get sheetPhysics => const ClampingScrollPhysics();

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> expand() async {
    await _animateTo(widget.maxChildSize);
  }

  Future<void> collapse() async {
    await _animateTo(widget.minChildSize);
  }

  void dragFromHeader(DragUpdateDetails details) {
    if (!_controller.isAttached) return;
    final height = MediaQuery.sizeOf(context).height;
    final nextSize = (_controller.size - details.delta.dy / height).clamp(
      widget.minChildSize,
      widget.maxChildSize,
    );
    _controller.jumpTo(nextSize);
  }

  void endDragFromHeader(DragEndDetails details) {
    if (!_controller.isAttached) return;

    final velocity = details.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;

    final target = velocity > velocityThreshold
        ? widget.minChildSize
        : widget.maxChildSize;

    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _animateTo(double size) async {
    if (!_controller.isAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.isAttached) return;
        _controller.animateTo(
          size,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
        );
      });
      return;
    }

    try {
      await _controller.animateTo(
        size,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: widget.initialChildSize,
        minChildSize: widget.minChildSize,
        maxChildSize: widget.maxChildSize,
        builder: (context, scrollController) {
          return Material(
            color: Colors.transparent,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 18,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: dragFromHeader,
                      onVerticalDragEnd: endDragFromHeader,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                        child: Column(
                          children: [
                            BarraAgarre(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Mapa', style: Theme.of(context).textTheme.labelMedium),
                                    Text('Zonas', style: Theme.of(context).textTheme.headlineSmall),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleIcon(
                                    onPressed: collapse,
                                    icon: Icons.close,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: sheetPhysics,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zonas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
