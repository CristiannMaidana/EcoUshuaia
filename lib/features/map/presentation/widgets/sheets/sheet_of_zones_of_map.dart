import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/zone_option_tile.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Diferent options of buttons
enum _ZoneSheetMode { hidden, all, mine, affected }

class SheetOfZonesOfMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  final Future<void> Function(double sheetHeight) onHideZones;
  final Future<void> Function(double sheetHeight) onShowAllZones;
  final Future<void> Function(double sheetHeight) onShowMyZone;
  final Future<void> Function(double sheetHeight) onShowAffectedZones;
  final Future<void> Function() backToUserLocation;

  const SheetOfZonesOfMap({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.47,
    this.maxSheetSize = 0.60,
    required this.onHideZones,
    required this.onShowAllZones,
    required this.onShowMyZone,
    required this.onShowAffectedZones,
    required this.backToUserLocation,
  });

  @override
  State<SheetOfZonesOfMap> createState() => SheetOfZonesOfMapState();
}

class SheetOfZonesOfMapState extends State<SheetOfZonesOfMap> {
  late final DraggableScrollableController draggableControllerOfZonesSheet;

  _ZoneSheetMode _appliedMode = _ZoneSheetMode.hidden;
  _ZoneSheetMode _selectedMode = _ZoneSheetMode.hidden;

  bool _isApplying = false;
  bool _wasSheetOpen = false;
  bool _isClosingSheet = false;

  double get _collapsedSheetSize => widget.initialSheetSize;
  double get _openedSheetSize => widget.minSheetSize;
  double get _expandedSheetSize => widget.maxSheetSize;
  double get _snapMidpoint => (_openedSheetSize + _expandedSheetSize) / 2;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfZonesSheet.isAttached) return 0.0;

    final currentSize = draggableControllerOfZonesSheet.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = _collapsedSheetSize + 0.12;

    // Evita división por 0 o rangos inválidos
    if (_openedSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (_openedSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    draggableControllerOfZonesSheet = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfZonesSheet.removeListener(_onSheetChanged);
    draggableControllerOfZonesSheet.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;

    final isSheetOpen = draggableControllerOfZonesSheet.size > _collapsedSheetSize;

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

  Future<void> expandSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;

    await draggableControllerOfZonesSheet.animateTo(
      _openedSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;

    _isClosingSheet = true;

    try {
      await draggableControllerOfZonesSheet.animateTo(
        _collapsedSheetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      widget.backToUserLocation();
    } finally {
      _isClosingSheet = false;
    }
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfZonesSheet.isAttached) return false;
    return draggableControllerOfZonesSheet.size > _collapsedSheetSize;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfZonesSheet.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfZonesSheet.size - detail.delta.dy / heightSheet)
            .clamp(_collapsedSheetSize, _expandedSheetSize);
    draggableControllerOfZonesSheet.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfZonesSheet.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfZonesSheet.size < (_openedSheetSize / 2);

    if (shouldClose) {
      _cancelChanges();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfZonesSheet.size < _snapMidpoint
            ? _openedSheetSize
            : _expandedSheetSize;

    draggableControllerOfZonesSheet.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // Functions specific to the sheet
  double _currentSheetHeight() {
    final size = draggableControllerOfZonesSheet.isAttached
        ? draggableControllerOfZonesSheet.size
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
    if (_isApplying) return;
    if (_selectedMode == mode) return;

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
  Widget build(BuildContext context) {
    final zonaVm = context.watch<ZonaMapaViewModel>();
    final usuarioZoneId = context.watch<UsuarioViewModel>().usuario?.idZona;
    final bool hasZones = zonaVm.hasItemsConCoordenadas;
    final userZone = zonaVm.zonaConCoordenadasPorId(usuarioZoneId);

    // Text of buttons of zones options
    final optionsZones = <_ZoneOptionData>[
      const _ZoneOptionData(
        mode: _ZoneSheetMode.all,
        title: 'Mostrar todas',
        subtitle: 'Muestra todas las zonas disponibles.',
      ),
      const _ZoneOptionData(
        mode: _ZoneSheetMode.mine,
        title: 'Mi zona',
        subtitle: 'Enfoca la zona asignada al usuario.',
      ),
      const _ZoneOptionData(
        mode: _ZoneSheetMode.hidden,
        title: 'Ocultar zonas',
        subtitle: 'Oculta las zonas del mapa.',
      ),
      const _ZoneOptionData(
        mode: _ZoneSheetMode.affected,
        title: 'Elegir zonas',
        subtitle: 'Seleccioná las zonas que querés ver en el mapa.',
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        // Functionality for close the sheet if is expand and touch out of the sheet.
        if (isExpandedSheet())
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _cancelChanges,
            child: const SizedBox.expand(),
          ),

        // -Sheet of zones-
        // Handle of the sheet settings
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfZonesSheet,
            initialChildSize: _collapsedSheetSize,
            minChildSize: _collapsedSheetSize,
            maxChildSize: _expandedSheetSize,
            builder: (context, scrollControllerDefault) {
              // Style of sheet for view
              return SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!,width: 1,),),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeOutCubic,
                    opacity: _contentOpacity,
                    child: Column(
                      children: [
                        // HEADER OF SHEET
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragUpdate: _dragFromHeaderSheet,
                          onVerticalDragEnd: _dragEndFromHeaderSheet,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            child: Column(
                              children: [
                                // Grab Bar
                                BarraAgarre(),
                                SizedBox(height: 8),

                                // Text of header and button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text of header
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Zonas del mapa',
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Gestiona la visualización de zonas en el mapa.',
                                          style: Theme.of(context).textTheme.labelMedium,),
                                        const SizedBox(height: 6),
                                        Text(userZone == null
                                              ? 'No se encontró una zona asignada para tu usuario.'
                                              : 'Tu zona es: ${userZone.nombreZona}.',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),

                                    // Button to close header
                                    CircleIcon(icon: Icons.close,
                                      onPressed: _cancelChanges,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // BODY
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollControllerDefault,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (zonaVm.loading)
                                    const Center(child: CircularProgressIndicator(),)
                                  else if (zonaVm.error != null)
                                    Text(zonaVm.error!,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    )
                                  else ...[
                                    const SizedBox(height: 16),
                                    Column(
                                      children: List.generate(
                                        optionsZones.length,
                                        (index) {
                                          final option = optionsZones[index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom:index ==optionsZones.length - 1
                                                  ? 0
                                                  : 10,
                                            ),
                                            child: ZoneOptionTile(
                                              title: option.title,
                                              subtitle: option.subtitle,
                                              selected: _selectedMode == option.mode,
                                              enabled: hasZones && !_isApplying,
                                              onTap: () => _selectMode(option.mode),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (_isApplying) ...[
                                      const SizedBox(height: 16),
                                      const LinearProgressIndicator(),
                                    ],
                                    const SizedBox(height: 20),

                                    // FOOTER
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: _isApplying
                                                ? null
                                                : _cancelChanges,
                                            child: const Text('Cancelar'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                hasZones && !_isApplying
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
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
