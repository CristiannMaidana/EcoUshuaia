import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:flutter/material.dart';

class SheetForChangeStylesOfMap extends SheetGeneric {
  final MapStyle selectedStyle;
  final Future<void> Function(MapStyle style) onStyleChanged;

  const SheetForChangeStylesOfMap({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.37,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  State<SheetForChangeStylesOfMap> createState() => SheetForChangeStylesOfMapState();
}

class SheetForChangeStylesOfMapState extends SheetGenericState<SheetForChangeStylesOfMap> {
  late MapStyle _selectedStyle;

  @override
  double get fadeStartSheetSize => initialChildSize + 0.09;

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.selectedStyle;
  }

  Future<void> _handleStyleChanged(MapStyle style) async {
    if (_selectedStyle == style) return;

    setState(() => _selectedStyle = style);
    await widget.onStyleChanged(style);
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BarraAgarre(),
          const SizedBox(height: 12),

          // Header row with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estilo de mapa',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Elegi como queres ver el mapa.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              CircleIcon(icon: Icons.close, onPressed: collapseSheet),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(22, 8, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MapStylePicker(
                seleccionado: _selectedStyle,
                onChanged: _handleStyleChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
