import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_container_options_map.dart';
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
  final Future<void> Function()? onClosed;

  const SheetZones({
    super.key,
    this.initialChildSize = SheetOptionsTheme.initialChildSize,
    this.minChildSize = SheetOptionsTheme.minChildSize,
    this.maxChildSize = SheetOptionsTheme.maxChildSize,
    required this.onHideZones,
    required this.onShowAllZones,
    required this.onShowMyZone,
    required this.onShowAffectedZones,
    this.onClosed,
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
    await widget.onClosed?.call();
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

    return SheetContainerOptionsMap(
      controller: _controller,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        _sheetScrollController = scrollController;
        return SheetOptionsPanel(
          scrollableBody: true,
          scrollController: scrollController,
          scrollPhysics: sheetPhysics,
          onHeaderVerticalDragUpdate: (details) =>
              SheetContainerOptionsMap.dragFromHeader(
                context: context,
                controller: _controller,
                details: details,
                minChildSize: widget.minChildSize,
                maxChildSize: widget.maxChildSize,
              ),
          onHeaderVerticalDragEnd: (details) =>
              SheetContainerOptionsMap.endDragFromHeader(
                controller: _controller,
                details: details,
                minChildSize: widget.minChildSize,
                maxChildSize: widget.maxChildSize,
                expandedChildSize: widget.maxChildSize,
                onClose: collapse,
                closeThreshold: widget.minChildSize,
              ),
          // Create widget for the header
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zonas del mapa',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gestiona la visualización de zonas en el mapa.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  if (!zonaVm.loading && zonaVm.error == null) ...[
                    const SizedBox(height: 6),
                    Text(
                      myZone == null
                          ? 'No se encontró una zona asignada para tu usuario.'
                          : 'Tu zona es ${myZone.nombreZona}.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              CircleIcon(onPressed: _cancelChanges, icon: Icons.close),
            ],
          ),
          // Create widget for the body
          body: _SheetZonesBody(
            zonaVm: zonaVm,
            options: options,
            draftMode: _draftMode,
            hasZones: hasZones,
            isApplying: _isApplying,
            onPreviewModeChange: _previewModeChange,
          ),
          // Create widget for the footer
          footer: zonaVm.loading || zonaVm.error != null
              ? null
              : Row(
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
        );
      },
    );
  }
}

// Widget of container of diferents zones
class _SheetZonesBody extends StatelessWidget {
  final ZonaMapaViewModel zonaVm;
  final List<_ZoneOptionData> options;
  final _ZoneSheetMode draftMode;
  final bool hasZones;
  final bool isApplying;
  final ValueChanged<_ZoneSheetMode> onPreviewModeChange;

  const _SheetZonesBody({
    required this.zonaVm,
    required this.options,
    required this.draftMode,
    required this.hasZones,
    required this.isApplying,
    required this.onPreviewModeChange,
  });

  @override
  Widget build(BuildContext context) {
    if (zonaVm.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (zonaVm.error != null) {
      return Text(zonaVm.error!, style: Theme.of(context).textTheme.bodyMedium);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(options.length, (index) {
            final option = options[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == options.length - 1 ? 0 : 10,
              ),
              child: ZoneOptionTile(
                title: option.title,
                subtitle: option.subtitle,
                selected: draftMode == option.mode,
                enabled: hasZones && !isApplying,
                onTap: () => onPreviewModeChange(option.mode),
              ),
            );
          }),
        ),
        if (isApplying) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
      ],
    );
  }
}

// Data of the diferents types of styles of zones
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
