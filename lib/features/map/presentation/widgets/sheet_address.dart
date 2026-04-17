import 'dart:async';

import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/address_list_item.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/detalle_ruta.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/header_for_addres_is_close.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddress extends StatefulWidget {
  final VoidCallback openOptionContainer;
  final String tuUbicacion;
  final String direccion;
  final Map<String, double> userPoint;
  final Future<void> Function() generateRouteCar;
  final Future<void> Function() generateRouteBike;
  final Future<void> Function() generateRouteWalk;
  final Future<void> Function(double height, String state)? onPreviewSheetMetricsChanged;
  final Future<void> Function() iniciarRuta;
  final Map<String, dynamic> navigationPayload;
  final Future<void> Function() cancelNavigation;

  const SheetAddress({
    super.key,
    required this.openOptionContainer,
    required this.tuUbicacion,
    required this.direccion,
    required this.userPoint,
    required this.generateRouteCar,
    required this.generateRouteBike,
    required this.generateRouteWalk,
    this.onPreviewSheetMetricsChanged,
    required this.iniciarRuta,
    required this.navigationPayload,
    required this.cancelNavigation,
  });

  @override
  State<SheetAddress> createState() => SheetAddressState();
}

class SheetAddressState extends State<SheetAddress> {
  FlotanteSheetState? get _sheet => context.findAncestorStateOfType<FlotanteSheetState>();

  bool _showBottomActions = true;
  bool botonSeleccionado = true;
  bool generarRuta = false;
  double? _lastPreviewSheetHeight;
  String? _lastPreviewSheetState;

  final Set<int> _contenedoresRutaIds = <int>{};

  late final List<_RutaItem> _rutaItems;

  /// Mantiene SIEMPRE el orden de los strings
  final ValueNotifier<List<String>> orderStrings = ValueNotifier<List<String>>(
    <String>[],
  );

  //==== Sincroniza el ValueNotifier con la lista actual ====//
  void _syncOrder([MapSearchViewModel? vmMapSearch]) {
    final next = List<String>.unmodifiable(
      _rutaItems.map((item) => _direccionForItem(vmMapSearch, item)).toList(),
    );
    if (!listEquals(orderStrings.value, next)) orderStrings.value = next;
  }

  // Obtiene direcciones y en base al elemento en parametro
  String _direccionForItem(MapSearchViewModel? vmMapSearch, _RutaItem item) {
    if (item.id == _RutaItemId.tuUbicacion) {
      if (vmMapSearch == null) return '';
      return _getDireccionFromUserPoint(vmMapSearch);
    }
    if (item.id == _RutaItemId.direccion) {
      return item.title;
    }
    if (item.contenedor == null) return '';
    if (vmMapSearch == null) return item.contenedor?.descripcionUbicacion ?? '';
    return _getDireccionFromContenedor(vmMapSearch, item.contenedor);
  }

  String _getDireccionFromContenedor(MapSearchViewModel vmMapSearch, Contenedor? contenedor) {
    final coord = contenedor?.coordenada;
    if (coord == null) return contenedor?.descripcionUbicacion ?? '';
    final direccion = vmMapSearch.getDireccionFromPoint(
      coord.latitud,
      coord.longitud,
    );
    if (direccion.isNotEmpty) return direccion;
    return contenedor?.descripcionUbicacion ?? '';
  }

  String _getDireccionFromUserPoint(MapSearchViewModel vmMapSearch) {
    final lat = widget.userPoint['lat'];
    final lon = widget.userPoint['lon'];
    if (lat == null || lon == null) return '';
    if (lat == 0 && lon == 0) return '';
    return vmMapSearch.getDireccionFromPoint(lat, lon);
  }

  void addContenedor(Contenedor contenedor) {
    if (!_contenedoresRutaIds.add(contenedor.idContenedor)) return;
    setState(() {
      _rutaItems.add(_RutaItem.contenedor(contenedor));
      _syncOrder();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex >= _rutaItems.length) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _rutaItems.removeAt(oldIndex);
      newIndex = newIndex.clamp(0, _rutaItems.length);
      _rutaItems.insert(newIndex, item);
      _syncOrder();
    });
  }

  void _onDismiss(_RutaItem item) {
    if (!item.isDismissible) return;
    final contenedor = item.contenedor!;
    context.read<ContenedorViewModel>().restoreCercanoById(contenedor.idContenedor);
    setState(() {
      _rutaItems.removeWhere((it) => it.id == item.id);
      _contenedoresRutaIds.remove(contenedor.idContenedor);
      _syncOrder();
    });
  }

  //==== Dragging para el header ====//
  // Actualiza la posición del sheet al arrastrar desde el header con el metodo del padre
  void _dragFromHeader(DragUpdateDetails d) {
    _sheet?.dragFromHeader(d);
  }

  void _endDragFromHeader(DragEndDetails d) {
    _sheet?.endDragFromHeader(d);
  }

  Future<void> expand() async {
    final sheet = _sheet;
    sheet?.showSecondChild();
  }

  void reportPreviewSheetMetrics() {
    final sheet = _sheet;
    if (sheet == null) return;
    _reportPreviewSheetMetrics(sheet, schedulePostFrame: false);
  }

  void _reportPreviewSheetMetrics(
    FlotanteSheetState sheet, {
    bool schedulePostFrame = true,
  }) {
    final state = _previewSheetStateFor(sheet);
    if (state == 'moving') return;

    final height = MediaQuery.sizeOf(context).height * sheet.currentSheetSize;
    final roundedHeight = height.roundToDouble();
    final lastHeight = _lastPreviewSheetHeight;
    final heightChanged =
        lastHeight == null || (lastHeight - roundedHeight).abs() >= 1;
    final stateChanged = _lastPreviewSheetState != state;

    if (!heightChanged && !stateChanged) return;

    _lastPreviewSheetHeight = roundedHeight;
    _lastPreviewSheetState = state;

    void notifyNativeMap() {
      if (!mounted) return;
      final callback = widget.onPreviewSheetMetricsChanged;
      if (callback == null) return;
      unawaited(callback(roundedHeight, state));
    }

    if (schedulePostFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyNativeMap());
    } else {
      notifyNativeMap();
    }
  }

  String _previewSheetStateFor(FlotanteSheetState sheet) {
    if (sheet.isFullyExpanded) return 'expanded';
    if (sheet.isCollapsed) return 'collapsed';

    final min = sheet.widget.minChildSize;
    final max = sheet.isShowingSecondChild
        ? (sheet.widget.maxChildSize2 ?? sheet.widget.maxChildSize)
        : sheet.widget.maxChildSize;
    final primary = sheet.isShowingSecondChild
        ? sheet.widget.secondChildInitialSize.clamp(min, max).toDouble()
        : _primarySnapPoint(sheet);

    if ((sheet.currentSheetSize - primary).abs() < 0.005) {
      return 'primary';
    }
    return 'moving';
  }

  double _primarySnapPoint(FlotanteSheetState sheet) {
    final snapPoints = List<double>.of(sheet.widget.snapPoints)..sort();
    if (snapPoints.length > 1) return snapPoints[1];
    return sheet.widget.minChildSize;
  }

  @override
  void initState() {
    super.initState();
    _rutaItems = <_RutaItem>[
      _RutaItem.fixed(
        id: _RutaItemId.tuUbicacion,
        title: widget.tuUbicacion,
      ),
      _RutaItem.fixed(
        id: _RutaItemId.direccion,
        title: widget.direccion,
      ),
    ];
    _syncOrder();

    orderStrings.addListener(() {
      debugPrint('Orden actualizado: ${orderStrings.value}');
    });
  }

  @override
  void didUpdateWidget(covariant SheetAddress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tuUbicacion == widget.tuUbicacion &&
        oldWidget.direccion == widget.direccion) {
      return;
    }
    setState(() {
      for (final item in _rutaItems) {
        if (item.id == _RutaItemId.tuUbicacion) {
          item.title = widget.tuUbicacion;
        } else if (item.id == _RutaItemId.direccion) {
          item.title = widget.direccion;
        }
      }
      _syncOrder();
    });
  }

  @override
  void dispose() {
    orderStrings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheet = _sheet!;
    final scrollController = PrimaryScrollController.of(context);
    MapSearchViewModel vmMapSearch = context.watch<MapSearchViewModel>();
    _syncOrder(vmMapSearch);

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: sheet.sheetSizeListenable,
            builder: (context, _, __) {
              _reportPreviewSheetMetrics(sheet);

              final snapPoints = List<double>.of(sheet.widget.snapPoints)..sort();
              final contentHiddenThreshold = sheet.widget.minChildSize;
              final contentFadeStartThreshold = snapPoints.length > 2
                  ? snapPoints[2]
                  : sheet.widget.maxChildSize;
              final fadeRange = contentFadeStartThreshold > contentHiddenThreshold
                  ? contentFadeStartThreshold - contentHiddenThreshold
                  : 0.0001;
              final transitionProgress =((sheet.currentSheetSize - contentHiddenThreshold) / fadeRange).clamp(0.0, 1.0);
              final expandedHeaderOpacity = transitionProgress;
              final collapsedHeaderOpacity = 1.0 - transitionProgress;
              final contentOpacity = transitionProgress.clamp(0.0, 1.0);

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Header colapsado
                      IgnorePointer(
                        ignoring: collapsedHeaderOpacity <= 0.01,
                        child: Opacity(
                          opacity: collapsedHeaderOpacity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: collapsedHeaderOpacity,
                            child: HeaderForAddressIsClose(
                              onVerticalDragUpdateFromFather: _dragFromHeader,
                              onVerticalDragEndFromFather: _endDragFromHeader,
                              address: widget.direccion,
                              onPressedClose: () {
                                _sheet?.showFirstChild();
                                _sheet?.expandSheet(); // Falta arreglar
                              },
                            ),
                          ),
                        ),
                      ),

                      // Header expandido
                      IgnorePointer(
                        ignoring: expandedHeaderOpacity <= 0.01,
                        child: Opacity(
                          opacity: expandedHeaderOpacity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: expandedHeaderOpacity,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onVerticalDragUpdate: _dragFromHeader,
                              onVerticalDragEnd: _endDragFromHeader,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BarraAgarre(),

                                    SizedBox(height: 12),

                                    //Header con direccion y boton de agregar parada
                                    Row(
                                      children: [
                                        // Contenedor para direccion con estilo de tarjeta
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dirección Ejemplo',
                                                style: Theme.of(context).textTheme.titleMedium
                                                    ?.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Calle Falsa 123, Ciudad, País',
                                                style: Theme.of(context).textTheme.bodySmall
                                                    ?.copyWith(color: Colors.grey.shade600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Boton para agregar parada
                                        CircleIcon(
                                          icon: Icons.add,
                                          onPressed: widget.openOptionContainer,
                                        ),
                                        SizedBox(width: 10),
                                        CircleIcon(
                                          icon: Icons.favorite,
                                          onPressed: () {},
                                        ),
                                        SizedBox(width: 10),
                                        CircleIcon(
                                          icon: Icons.close,
                                          onPressed: () {
                                            _sheet?.showFirstChild();
                                            _sheet?.collapseSheet();
                                            widget.cancelNavigation();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Contenido del sheet
                  Expanded(
                    child: sheet.isCollapsed
                        ? CustomScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: const [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: SizedBox.expand(),
                              ),
                            ],
                          )
                        : IgnorePointer(
                            ignoring: contentOpacity < 0.2,
                            child: Opacity(
                              opacity: contentOpacity,
                              child: Column(
                                children: [
                                  SizedBox(width: double.infinity, child: lineDivider()),
                                  // Acciones para elegir tipo de ruta
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(width: 1, color: Colors.grey.shade300,),
                                              color: Colors.grey.shade100,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.generateRouteCar();
                                                      _showBottomActions = !_showBottomActions;
                                                      botonSeleccionado = !botonSeleccionado;
                                                      generarRuta = !generarRuta;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.directions_car),
                                                  color: botonSeleccionado
                                                      ? Colors.black
                                                      : Colors.blue.shade300,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState((){
                                                      widget.generateRouteBike();
                                                      _showBottomActions = !_showBottomActions;
                                                      generarRuta = !generarRuta;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.directions_bike),
                                                  color: Colors.grey.shade700,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.generateRouteWalk();
                                                      _showBottomActions = !_showBottomActions;
                                                      generarRuta = !generarRuta;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.directions_walk),
                                                  color: Colors.grey.shade700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Lista de paradas agregadas a la ruta
                                  Expanded(
                                    child: ReorderableListView.builder(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      scrollController: scrollController,
                                      itemCount: _rutaItems.length,
                                      onReorder: _onReorder,
                                      buildDefaultDragHandles: false,
                                      footer: Padding(
                                        key: const ValueKey('detalle_ruta'),
                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8,),
                                        child: DetalleRuta(
                                          botonIr: widget.iniciarRuta,
                                          routePayload: widget.navigationPayload,
                                        ),
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = _rutaItems[index];
                                        final direccion = _direccionForItem(vmMapSearch, item);
                                        final child = AddressListItem(
                                          key: ValueKey(item.id),
                                          title: item.title,
                                          direccion: direccion,
                                          dragHandle: ReorderableDragStartListener(
                                            index: index,
                                            child: const _HandleIcon(),
                                          ),
                                        );

                                        if (!item.isDismissible) return child;

                                        return Dismissible(
                                          key: ValueKey('dismiss_${item.id}'),
                                          direction: DismissDirection.horizontal,
                                          background: _dismissBg(Alignment.centerLeft),
                                          secondaryBackground: _dismissBg(Alignment.centerRight),
                                          onDismissed: (_) => _onDismiss(item),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//==== Helpers ====//
// Fondo visual para el swipe (simple, sin afectar lógica)
Widget _dismissBg(Alignment alignment) {
  return Container(
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.redAccent,
    child: const Icon(Icons.delete, color: Colors.white),
  );
}

/// Handle visual para arrastrar
class _HandleIcon extends StatelessWidget {
  const _HandleIcon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8),
      child: Icon(Icons.drag_handle, color: Colors.grey),
    );
  }
}

abstract final class _RutaItemId {
  static const String tuUbicacion = 'tu_ubicacion';
  static const String direccion = 'direccion';
}

// Mapea y une Strings con contenedores
class _RutaItem {
  final String id;
  String title;
  final Contenedor? contenedor;
  final bool isDismissible;

  _RutaItem._({
    required this.id,
    required this.title,
    required this.contenedor,
    required this.isDismissible,
  });

  factory _RutaItem.fixed({required String id, required String title}) {
    return _RutaItem._(
      id: id,
      title: title,
      contenedor: null,
      isDismissible: false,
    );
  }

  factory _RutaItem.contenedor(Contenedor contenedor) {
    return _RutaItem._(
      id: 'contenedor_${contenedor.idContenedor}',
      title: contenedor.nombreContenedor ?? 'Contenedor ${contenedor.idContenedor}',
      contenedor: contenedor,
      isDismissible: true,
    );
  }
}
