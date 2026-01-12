import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/address_list_item.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/detalle_ruta.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddress extends StatefulWidget {
  final VoidCallback openOptionContainer;
  final String tuUbicacion;
  final String direccion;
  final Map<String, double> userPoint;

  const SheetAddress({
    super.key,
    required this.openOptionContainer,
    required this.tuUbicacion,
    required this.direccion,
    required this.userPoint,
  });

  @override
  State<SheetAddress> createState() => SheetAddressState();
}

class SheetAddressState extends State<SheetAddress> {
  FlotanteSheetState? get _sheet => context.findAncestorStateOfType<FlotanteSheetState>();

  bool _showBottomActions = true;
  bool botonSeleccionado = true;
  bool generarRuta = false;

  final Set<int> _contenedoresRutaIds = <int>{};

  late final List<_RutaItem> _rutaItems;

  /// Mantiene SIEMPRE el orden de los strings
  final ValueNotifier<List<String>> orderStrings = ValueNotifier<List<String>>(
    <String>[],
  );

  //==== Sincroniza el ValueNotifier con la lista actual ====//
  void _syncOrder() {
    orderStrings.value = List.unmodifiable(
      _rutaItems.map((item) => item.title).toList(),
    );
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
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _rutaItems.removeAt(oldIndex);
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          'Eliminado: ${item.title}',
        ),
      ),
    );
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
    final scrollController = PrimaryScrollController.of(context);
    MapSearchViewModel vmMapSearch = context.watch<MapSearchViewModel>();

    final outlineBtnStyle = OutlinedButton.styleFrom(
      shape: const StadiumBorder(),
      side: BorderSide(color: Colors.grey.shade400),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Column(
            children: [
              // ===== Header =====
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: _dragFromHeader,
                onVerticalDragEnd: _endDragFromHeader,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra de agarre
                      BarraAgarre(),

                      // Header con titulo y boton principal
                      Row(
                        children: [
                          // TODO: Cambiar por datos reales de la dirección seleccionada desde vm
                          //Texto informacion de direccion seleccionada
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
                          ElevatedButton(
                            onPressed: widget.openOptionContainer,
                            child: Row(
                              children: [
                                Icon(Icons.add_circle),
                                SizedBox(width: 8),
                                Text('Parada'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Separador fino
              SizedBox(width: double.infinity, child: lineDivider()),

              // ===== Controles de navegacion =====
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

              // ===== Lista de direcciones =====
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  scrollController: scrollController,
                  itemCount: _rutaItems.length,
                  onReorder: _onReorder,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final item = _rutaItems[index];
                    final direccion = item.id == _RutaItemId.tuUbicacion
                        ? (vmMapSearch == null ? '' : _getDireccionFromUserPoint(vmMapSearch))
                        : item.id == _RutaItemId.direccion
                            ? item.title
                            : item.contenedor == null
                                ? ''
                                : (vmMapSearch == null
                                    ? (item.contenedor?.descripcionUbicacion ?? '')
                                    : _getDireccionFromContenedor(vmMapSearch, item.contenedor));
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

              // ===== Detalle de ruta =====
              if (generarRuta)
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 6, 12, 8),
                child: DetalleRuta(),
              ),

              // ===== Botones fijos =====
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      OutlinedButton(
                        style: outlineBtnStyle,
                        onPressed: () {
                          _sheet?.showFirstChild();
                          _sheet?.collapseSheet();
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.cancel, color: Colors.black),
                            const SizedBox(width: 8),
                            Text('Cancelar', style: Theme.of(context).textTheme.labelLarge,),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (_showBottomActions)
                        OutlinedButton(
                          style: outlineBtnStyle,
                          onPressed: () {},
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.black),
                              const SizedBox(width: 8),
                              Text('Guardar', style: Theme.of(context).textTheme.labelLarge,),
                            ],
                          ),
                        ),
                      if (_showBottomActions) const SizedBox(width: 10),
                      if (_showBottomActions)
                        OutlinedButton(
                          style: outlineBtnStyle,
                          onPressed: () {},
                          child: Row(
                            children: [
                              const Icon(Icons.report, color: Colors.black),
                              const SizedBox(width: 8),
                              Text('Reportar', style: Theme.of(context).textTheme.labelLarge),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
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

  factory _RutaItem.fixed({
    required String id,
    required String title,
  }) {
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
