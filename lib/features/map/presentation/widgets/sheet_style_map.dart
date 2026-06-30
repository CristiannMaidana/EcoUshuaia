import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_container_options_map.dart';
import 'package:flutter/material.dart';

class SheetStyleMap extends StatefulWidget {
  final MapStyle selectedStyle;
  final Future<void> Function(MapStyle style) onStyleChanged;

  const SheetStyleMap({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required MapStyle selectedStyle,
    required Future<void> Function(MapStyle style) onStyleChanged,
  }) {
    return SheetOptionsModal.show<void>(
      context,
      heightFactor: 1,
      child: SheetStyleMap(
        selectedStyle: selectedStyle,
        onStyleChanged: onStyleChanged,
      ),
    );
  }

  @override
  State<SheetStyleMap> createState() => _SheetStyleMapState();
}

class _SheetStyleMapState extends State<SheetStyleMap> {
  late final DraggableScrollableController _controller;
  late MapStyle _selectedStyle;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _selectedStyle = widget.selectedStyle;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleStyleChanged(MapStyle style) async {
    if (_selectedStyle == style) return;

    setState(() => _selectedStyle = style);
    await widget.onStyleChanged(style);
  }

  Future<void> _closeSheet() async {
    await _controller.animateTo(
      SheetOptionsTheme.minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _dragFromHeader(DragUpdateDetails details) {
    if (!_controller.isAttached) return;
    final height = MediaQuery.sizeOf(context).height;
    final nextSize = (_controller.size - details.delta.dy / height).clamp(
      SheetOptionsTheme.minChildSize,
      SheetOptionsTheme.maxChildSize,
    );
    _controller.jumpTo(nextSize);
  }

  void _endDragFromHeader(DragEndDetails details) {
    if (!_controller.isAttached) return;

    final velocity = details.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = velocity > velocityThreshold || _controller.size < 0.30;

    if (shouldClose) {
      _closeSheet();
      return;
    }

    _controller.animateTo(
      SheetOptionsTheme.maxChildSize,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainerOptionsMap(
      controller: _controller,
      initialChildSize: .38,
      minChildSize: SheetOptionsTheme.minChildSize,
      maxChildSize: .38,
      builder: (context, scrollController) {
        return SheetOptionsPanel(
          expandBody: false,
          scrollableBody: true,
          scrollController: scrollController,
          onHeaderVerticalDragUpdate: _dragFromHeader,
          onHeaderVerticalDragEnd: _endDragFromHeader,
          // Create widget with content of the header
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estilo de mapa',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Elegi como queres ver el mapa.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              CircleIcon(icon: Icons.close, onPressed: _closeSheet),
            ],
          ),
          // Create widget with content of the body
          body: MapStylePicker(
            seleccionado: _selectedStyle,
            onChanged: _handleStyleChanged,
          ),
        );
      },
    );
  }
}
