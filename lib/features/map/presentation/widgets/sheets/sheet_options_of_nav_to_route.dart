import 'dart:async';

import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/card_of_address_selected.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/button_start_route.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/header_for_addres_is_close.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/buttons_type_mobility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOptionsOfNavToRoute extends StatefulWidget {
  final VoidCallback openOptionContainer;
  final String tuUbicacion;
  final String direccion;
  final Map<String, double> userPoint;
  final Map<String, double> destinationPoint;
  final Future<void> Function({required String profile, List<Map<String, double>>? routePoints}) generateRoute;
  final Future<void> Function(double height, String state)? onPreviewSheetMetricsChanged;
  final Future<void> Function() iniciarRuta;
  final Map<String, dynamic> navigationPayload;
  final Future<void> Function() cancelNavigation;
  final Future<void> Function() cancelSetCamera;

  const SheetOptionsOfNavToRoute({
    super.key,
    required this.openOptionContainer,
    required this.tuUbicacion,
    required this.direccion,
    required this.userPoint,
    required this.destinationPoint,
    required this.generateRoute,
    this.onPreviewSheetMetricsChanged,
    required this.iniciarRuta,
    required this.navigationPayload,
    required this.cancelNavigation,
    required this.cancelSetCamera,
  });

  @override
  State<SheetOptionsOfNavToRoute> createState() => SheetOptionsOfNavToRouteState();
}

class SheetOptionsOfNavToRouteState extends State<SheetOptionsOfNavToRoute> {
  FlotanteSheetState? get _sheet => context.findAncestorStateOfType<FlotanteSheetState>();

  int _selectedRouteProfile = -1;
  double? _lastPreviewSheetHeight;
  String? _lastPreviewSheetState;

  final Set<int> _contenedoresRutaIds = <int>{};

  late final List<_RutaItem> _rutaItems;

  /// Mantiene SIEMPRE el orden de los strings
  final ValueNotifier<List<String>> orderStrings = ValueNotifier<List<String>>(
    <String>[],
  );

  //==== Sincroniza el ValueNotifier con la lista actual ====//
  void _syncOrderOfRoute([MapSearchViewModel? vmMapSearch]) {
    final next = List<String>.unmodifiable(
      _rutaItems.map((item) => _getDirectionOfItem(vmMapSearch, item)).toList(),
    );
    if (!listEquals(orderStrings.value, next)) orderStrings.value = next;
  }

  List<Map<String, double>>? _orderedRoutePoints() {
    final points = <Map<String, double>>[];
    for (final item in _rutaItems) {
      double? lat;
      double? lon;
      if (item.id == _RutaItemId.tuUbicacion) {
        lat = widget.userPoint['lat'];
        lon = widget.userPoint['lon'];
      } else if (item.id == _RutaItemId.direccion) {
        lat = widget.destinationPoint['lat'];
        lon = widget.destinationPoint['lon'];
      } else {
        lat = item.contenedor?.coordenada?.latitud;
        lon = item.contenedor?.coordenada?.longitud;
      }
      if (lat == null || lon == null) return null;
      if (lat == 0 && lon == 0) return null;
      points.add(<String, double>{'lat': lat, 'lon': lon});
    }
    return points.length >= 2 ? List<Map<String, double>>.unmodifiable(points) : null;
  }

  void _regenerateSelectedRoute() {
    if (_selectedRouteProfile < 0) return;

    final routePoints = _orderedRoutePoints();
    if (routePoints == null) return;
    
    unawaited(widget.generateRoute(
      profile: _getProfileOfRoute(_selectedRouteProfile),
      routePoints: routePoints,
    ));
  }

  String _getProfileOfRoute(int perfilRoute) {
    if (perfilRoute == 1) return 'cycling';
    if (perfilRoute == 2) return 'walking';
    return 'automobile';
  }

  void _listenerOnOrderStringsChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _regenerateSelectedRoute();
    });
  }

  void _selectPerfilOfRouteAndGenereteIt(int perfilRoute) {
    final routePoints = _orderedRoutePoints();
    
    setState(() {
      widget.generateRoute(
        profile: _getProfileOfRoute(perfilRoute),
        routePoints: routePoints,
      );
      _selectedRouteProfile = perfilRoute;
    });
  }


  String _getDirectionOfItem(MapSearchViewModel? vmMapSearch, _RutaItem item) {
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
    final directionFromPoints = vmMapSearch.getDireccionFromPoint(
      coord.latitud,
      coord.longitud,
    );
    if (directionFromPoints.isNotEmpty) return directionFromPoints;
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
      _syncOrderOfRoute();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex >= _rutaItems.length) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _rutaItems.removeAt(oldIndex);
      newIndex = newIndex.clamp(0, _rutaItems.length);
      _rutaItems.insert(newIndex, item);
      _syncOrderOfRoute();
    });
  }

  void _onDismiss(_RutaItem item) {
    if (!item.isDismissible) return;
    final contenedor = item.contenedor!;
    context.read<ContenedorViewModel>().restoreCercanoById(contenedor.idContenedor);
    setState(() {
      _rutaItems.removeWhere((it) => it.id == item.id);
      _contenedoresRutaIds.remove(contenedor.idContenedor);
      _syncOrderOfRoute();
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
    _syncOrderOfRoute();

    orderStrings.addListener(_listenerOnOrderStringsChanged);
  }

  @override
  void didUpdateWidget(covariant SheetOptionsOfNavToRoute oldWidget) {
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
      _syncOrderOfRoute();
    });
  }

  @override
  void dispose() {
    orderStrings.removeListener(_listenerOnOrderStringsChanged);
    orderStrings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheet = _sheet!;
    final scrollController = PrimaryScrollController.of(context);
    MapSearchViewModel vmMapSearch = context.watch<MapSearchViewModel>();
    _syncOrderOfRoute(vmMapSearch);

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
                                              Text('Cómo llegar',
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                              const SizedBox(height: 5,),
                                              Text('Elegí la mejor opción para tu ruta', 
                                                style: Theme.of(context).textTheme.labelMedium,
                                              )
                                            ],
                                          ),
                                        ),

                                        // SECTION OF BUTTONS
                                        // Boton para agregar parada de contenedores
                                        CircleIcon(icon: Icons.add,
                                          onPressed: widget.openOptionContainer,
                                        ),
                                        SizedBox(width: 10),
                                        // Button for close the sheet
                                        CircleIcon(icon: Icons.close,
                                          onPressed: () {
                                            _sheet?.showFirstChild();
                                            _sheet?.collapseSheet();
                                            widget.cancelNavigation();
                                            widget.cancelSetCamera();
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
                  //Cambiar color a icons seleccionados
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
                                  // Boton para elegir tipo perfil de ruta
                                  ButtonsTypeMobility(
                                    selectedRouteProfile: _selectedRouteProfile,
                                    onCarPressed: () => _selectPerfilOfRouteAndGenereteIt(0),
                                    onBikePressed: () => _selectPerfilOfRouteAndGenereteIt(1),
                                    onWalkPressed: () => _selectPerfilOfRouteAndGenereteIt(2),
                                  ),
                                      
                                  // Lista de paradas agregadas a la ruta
                                  Expanded(
                                    child: ReorderableListView.builder(
                                      scrollController: scrollController,
                                      itemCount: _rutaItems.length,
                                      onReorder: _onReorder,
                                      buildDefaultDragHandles: false,
                                      footer: Padding(
                                        key: const ValueKey('detalle_ruta'),
                                        padding: const EdgeInsets.fromLTRB(12, 15, 12, 8,),
                                        child: ButtonStartRoute(
                                          botonIr: widget.iniciarRuta,
                                          routePayload: widget.navigationPayload,
                                        ),
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = _rutaItems[index];
                                        final direccion = _getDirectionOfItem(vmMapSearch, item);
                                        final child = CardOfAddressSelected(
                                          key: ValueKey(item.id),
                                          title: item.id == _RutaItemId.direccion ? 'Destino' : item.title,
                                          direccion: direccion,
                                          dragHandle: ReorderableDragStartListener(
                                            index: index,
                                            child: const Icon(Icons.drag_handle, color: Colors.grey)
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
    child: const Icon(Icons.delete, color: Colors.white, size: 30,),
  );
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
