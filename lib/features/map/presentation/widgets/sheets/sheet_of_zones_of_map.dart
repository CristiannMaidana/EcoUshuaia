import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/zone_option_tile.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _ZoneSheetMode { hidden, all, mine, affected }

class SheetOfZonesOfMap extends SheetGeneric {
  final Future<void> Function(double sheetHeight) onHideZones;
  final Future<void> Function(double sheetHeight) onShowAllZones;
  final Future<void> Function(double sheetHeight) onShowMyZone;
  final Future<void> Function(double sheetHeight) onShowAffectedZones;
  final Future<void> Function() backToUserLocation;

  const SheetOfZonesOfMap({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.47,
    super.maxSheetSize = 0.60,
    required this.onHideZones,
    required this.onShowAllZones,
    required this.onShowMyZone,
    required this.onShowAffectedZones,
    required this.backToUserLocation,
  });

  @override
  State<SheetOfZonesOfMap> createState() => SheetOfZonesOfMapState();
}

class SheetOfZonesOfMapState extends SheetGenericState<SheetOfZonesOfMap> {
  _ZoneSheetMode _appliedMode = _ZoneSheetMode.hidden;
  _ZoneSheetMode _selectedMode = _ZoneSheetMode.hidden;

  bool _isApplying = false;
  bool _wasSheetOpen = false;
  bool _isClosingSheet = false;

  double get _collapsedSheetSize => widget.initialSheetSize;
  double get _openedSheetSize => widget.minSheetSize;
  double get _expandedSheetSize => widget.maxSheetSize;

  @override
  double get initialChildSize => _collapsedSheetSize;

  @override
  double get minChildSize => _collapsedSheetSize;

  @override
  double get maxChildSize => _expandedSheetSize;

  @override
  double get snapMidpoint => (_openedSheetSize + _expandedSheetSize) / 2;

  @override
  double get fadeStartSheetSize => _collapsedSheetSize + 0.12;

  @override
  double get fadeEndSheetSize => _openedSheetSize;

  @override
  void onSheetChanged() {
    if (!mounted || !draggableControllerOfSheet.isAttached) return;

    final isSheetOpen = draggableControllerOfSheet.size > _collapsedSheetSize;

    if (isSheetOpen) {
      _wasSheetOpen = true;
    } else if (_wasSheetOpen) {
      _wasSheetOpen = false;
      if (!_isClosingSheet) {
        _cancelChanges();
      }
    }

    setState(() {});
  }

  @override
  Future<void> expandSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    await draggableControllerOfSheet.animateTo(
      _openedSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    _isClosingSheet = true;

    try {
      await super.collapseSheet();
      widget.backToUserLocation();
    } finally {
      _isClosingSheet = false;
    }
  }

  @override
  bool isExpandedSheet() {
    if (!draggableControllerOfSheet.isAttached) return false;
    return draggableControllerOfSheet.size > _collapsedSheetSize;
  }

  @override
  void onTapOutsideSheet() {
    _cancelChanges();
  }

  @override
  void dragEndFromHeaderSheet(DragEndDetails details) {
    if (!draggableControllerOfSheet.isAttached) return;

    final dragVelocity = details.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose =
        dragVelocity > velocityThreshold ||
        draggableControllerOfSheet.size < _openedSheetSize / 2;

    if (shouldClose) {
      _cancelChanges();
      return;
    }

    final targetSheetSize = draggableControllerOfSheet.size < snapMidpoint
        ? _openedSheetSize
        : _expandedSheetSize;

    draggableControllerOfSheet.animateTo(
      targetSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  double _currentSheetHeight() {
    final size = draggableControllerOfSheet.isAttached
        ? draggableControllerOfSheet.size
        : _openedSheetSize;
    return MediaQuery.sizeOf(context).height * size;
  }

  Future<void> _runMode(_ZoneSheetMode mode) async {
    final sheetHeight = _currentSheetHeight();

    final action = switch (mode) {
      _ZoneSheetMode.hidden => widget.onHideZones,
      _ZoneSheetMode.all => widget.onShowAllZones,
      _ZoneSheetMode.mine => widget.onShowMyZone,
      _ZoneSheetMode.affected => widget.onShowAffectedZones,
    };

    await action(sheetHeight);
  }

  Future<void> _selectMode(_ZoneSheetMode mode) async {
    if (_isApplying || _selectedMode == mode) return;

    setState(() => _isApplying = true);

    try {
      await _runMode(mode);

      if (!mounted) return;
      setState(() {
        _selectedMode = mode;
      });
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }

  Future<void> _cancelChanges() async {
    if (_isApplying) return;

    if (_selectedMode != _appliedMode) {
      setState(() => _isApplying = true);

      try {
        await _runMode(_appliedMode);
      } finally {
        if (mounted) {
          setState(() {
            _selectedMode = _appliedMode;
            _isApplying = false;
          });
        }
      }
    }

    await collapseSheet();
  }

  Future<void> _applyChanges() async {
    if (_isApplying) return;

    setState(() {
      _appliedMode = _selectedMode;
    });

    await collapseSheet();
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    final zonaVm = context.watch<ZonaMapaViewModel>();
    final usuarioZoneId = context.watch<UsuarioViewModel>().usuario?.idZona;
    final userZone = zonaVm.zonaConCoordenadasPorId(usuarioZoneId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),
          
          // Header row with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zonas del mapa',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Gestiona la visualización de zonas en el mapa.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(userZone == null
                        ? 'No se encontró una zona asignada para tu usuario.'
                        : 'Tu zona es: ${userZone.nombreZona}.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              CircleIcon(icon: Icons.close, onPressed: _cancelChanges),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    final zonaVm = context.watch<ZonaMapaViewModel>();
    final hasZones = zonaVm.hasItemsConCoordenadas;
    const optionsZones = <_ZoneOptionData>[
      _ZoneOptionData(
        mode: _ZoneSheetMode.all,
        title: 'Mostrar todas',
        subtitle: 'Muestra todas las zonas disponibles.',
      ),
      _ZoneOptionData(
        mode: _ZoneSheetMode.mine,
        title: 'Mi zona',
        subtitle: 'Enfoca la zona asignada al usuario.',
      ),
      _ZoneOptionData(
        mode: _ZoneSheetMode.hidden,
        title: 'Ocultar zonas',
        subtitle: 'Oculta las zonas del mapa.',
      ),
      _ZoneOptionData(
        mode: _ZoneSheetMode.affected,
        title: 'Elegir zonas',
        subtitle: 'Seleccioná las zonas que querés ver en el mapa.',
      ),
    ];

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (zonaVm.loading)
                const Center(child: CircularProgressIndicator())
              else if (zonaVm.error != null)
                Text(
                  zonaVm.error!,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else ...[
                const SizedBox(height: 16),
                Column(
                  children: List.generate(optionsZones.length, (index) {
                    final option = optionsZones[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == optionsZones.length - 1 ? 0 : 10,
                      ),
                      child: ZoneOptionTile(
                        title: option.title,
                        subtitle: option.subtitle,
                        selected: _selectedMode == option.mode,
                        enabled: hasZones && !_isApplying,
                        onTap: () => _selectMode(option.mode),
                      ),
                    );
                  }),
                ),
                if (_isApplying) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isApplying ? null : _cancelChanges,
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: hasZones && !_isApplying
                            ? _applyChanges
                            : null,
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}

class _ZoneOptionData {
  final _ZoneSheetMode mode;
  final String title;
  final String subtitle;

  const _ZoneOptionData({
    required this.mode,
    required this.title,
    required this.subtitle,
  });
}
