import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/zone_option_tile.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _ZoneSheetMode { hidden, all, mine, affected }

class SheetZones extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Future<void> Function(double sheetHeight) onHideZones;
  final Future<void> Function(double sheetHeight) onShowAllZones;
  final Future<void> Function(double sheetHeight) onShowMyZone;
  final Future<void> Function(double sheetHeight)
  onShowAffectedZones; // Change for list of zones

  const SheetZones({
    super.key,
    this.initialChildSize = 0.0,
    this.minChildSize = 0.0,
    this.maxChildSize = 0.5,
    required this.onHideZones,
    required this.onShowAllZones,
    required this.onShowMyZone,
    required this.onShowAffectedZones,
  });

  @override
  State<SheetZones> createState() => SheetZonesState();
}

class SheetZonesState extends State<SheetZones> {
  late final DraggableScrollableController _controller;
  ScrollController? _sheetScrollController;
  _ZoneSheetMode _appliedMode = _ZoneSheetMode.hidden;
  _ZoneSheetMode _draftMode = _ZoneSheetMode.hidden;
  _ZoneSheetMode _previewMode = _ZoneSheetMode.hidden;
  bool _isApplying = false;

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
    if (mounted) {
      setState(() {
        _draftMode = _appliedMode;
        _previewMode = _appliedMode;
      });
    }
    _resetScrollToTop();
    await _animateTo(widget.maxChildSize);
  }

  Future<void> collapse() async {
    _resetScrollToTop();
    await _animateTo(widget.minChildSize);
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

  double _currentSheetHeight() {
    final size = _controller.isAttached
        ? _controller.size
        : widget.maxChildSize;
    return (MediaQuery.sizeOf(context).height * size).roundToDouble();
  }

  void _resetScrollToTop() {
    final controller = _sheetScrollController;
    if (controller == null || !controller.hasClients) return;
    controller.jumpTo(0);
  }

  Future<void> _previewModeChange(_ZoneSheetMode mode) async {
    if (_isApplying) return;
    if (_draftMode == mode && _previewMode == mode) return;

    setState(() => _isApplying = true);
    try {
      await _runMode(mode);
      if (!mounted) return;
      setState(() {
        _draftMode = mode;
        _previewMode = mode;
      });
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  Future<void> _cancelChanges() async {
    if (_isApplying) return;

    if (_previewMode != _appliedMode) {
      setState(() => _isApplying = true);
      try {
        await _runMode(_appliedMode);
      } finally {
        if (mounted) {
          setState(() {
            _draftMode = _appliedMode;
            _previewMode = _appliedMode;
            _isApplying = false;
          });
        }
      }
    } else if (mounted) {
      setState(() => _draftMode = _appliedMode);
    }

    await collapse();
  }

  Future<void> _applyChanges() async {
    if (_isApplying) return;
    if (mounted) {
      setState(() => _appliedMode = _draftMode);
    }
    await collapse();
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
    final zonaVm = context.watch<ZonaMapaViewModel>();
    final usuarioZoneId = context.watch<UsuarioViewModel>().usuario?.idZona;
    final zonas = zonaVm.items
        .where((zona) => zona.coordenada != null)
        .toList(growable: false);
    ZonaMapa? myZone;
    for (final zona in zonas) {
      if (zona.idZona == usuarioZoneId) {
        myZone = zona;
        break;
      }
    }
    final hasZones = zonas.isNotEmpty;
    final options = <_ZoneOptionData>[
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
        subtitle: 'Ocultar zonas del mapa.',
      ),
      const _ZoneOptionData(
        mode: _ZoneSheetMode.affected,
        title: 'Elegir zonas',
        subtitle: 'Seleccione las zona que desea ver en el mapa.',
      ),
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: widget.initialChildSize,
        minChildSize: widget.minChildSize,
        maxChildSize: widget.maxChildSize,
        builder: (context, scrollController) {
          _sheetScrollController = scrollController;
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
                                    Text(
                                      'Mapa',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Zonas',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleIcon(
                                    onPressed: _cancelChanges,
                                    icon: Icons.close,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: sheetPhysics,
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Elegí cómo querés ver las zonas en el mapa.',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 6),
                            if (zonaVm.loading)
                              const Center(child: CircularProgressIndicator())
                            else if (zonaVm.error != null)
                              Text(
                                zonaVm.error!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            else ...[
                              const SizedBox(height: 2),
                              Text(
                                myZone == null
                                    ? 'No se encontró una zona asignada para tu usuario.'
                                    : 'Tu zona es ${myZone.nombreZona}.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 16),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  children: List.generate(options.length, (
                                    index,
                                  ) {
                                    final option = options[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: index == options.length - 1
                                            ? 0
                                            : 10,
                                      ),
                                      child: ZoneOptionTile(
                                        title: option.title,
                                        subtitle: option.subtitle,
                                        selected: _draftMode == option.mode,
                                        enabled: hasZones && !_isApplying,
                                        onTap: () =>
                                            _previewModeChange(option.mode),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              if (_isApplying) ...[
                                const SizedBox(height: 16),
                                const LinearProgressIndicator(),
                              ],
                              const SizedBox(height: 20),
                              // Button of actions
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _isApplying
                                          ? null
                                          : _cancelChanges,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: camarone800,
                                        side: const BorderSide(
                                          color: camarone300,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Cancelar'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: hasZones && !_isApplying
                                          ? _applyChanges
                                          : null,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: camarone500,
                                        foregroundColor: colorNegro,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
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
