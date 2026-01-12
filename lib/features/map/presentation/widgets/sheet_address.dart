import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/address_list_item.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/detalle_ruta.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddress extends StatefulWidget {
  final VoidCallback openOptionContainer;

  const SheetAddress({
    super.key,
    required this.openOptionContainer,
  });

  @override
  State<SheetAddress> createState() => SheetAddressState();
}

class SheetAddressState extends State<SheetAddress> {
  FlotanteSheetState? get _sheet => context.findAncestorStateOfType<FlotanteSheetState>();

  bool _showBottomActions = true;
  bool botonSeleccionado = true;
  bool generarRuta = false;

  final List<Contenedor> _contenedoresRuta = <Contenedor>[];
  final Set<int> _contenedoresRutaIds = <int>{};

  /// Mantiene SIEMPRE el orden de los strings
  final ValueNotifier<List<String>> orderStrings = ValueNotifier<List<String>>(
    <String>[],
  );

  //==== Sincroniza el ValueNotifier con la lista actual ====//
  void _syncOrder() {
    orderStrings.value = List.unmodifiable(
      _contenedoresRuta
          .map((c) => c.nombreContenedor ?? 'Contenedor ${c.idContenedor}')
          .toList(),
    );
  }

  void addContenedor(Contenedor contenedor) {
    if (!_contenedoresRutaIds.add(contenedor.idContenedor)) return;
    setState(() {
      _contenedoresRuta.add(contenedor);
      _syncOrder();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _contenedoresRuta.removeAt(oldIndex);
      _contenedoresRuta.insert(newIndex, item);
      _syncOrder();
    });
  }

  void _onDismiss(Contenedor contenedor) {
    context.read<ContenedorViewModel>().restoreCercanoById(contenedor.idContenedor);
    setState(() {
      _contenedoresRuta.removeWhere((c) => c.idContenedor == contenedor.idContenedor);
      _contenedoresRutaIds.remove(contenedor.idContenedor);
      _syncOrder();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          'Eliminado: ${contenedor.nombreContenedor ?? 'Contenedor ${contenedor.idContenedor}'}',
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
    _syncOrder();

    orderStrings.addListener(() {
      debugPrint('Orden actualizado: ${orderStrings.value}');
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
                  itemCount: _contenedoresRuta.length,
                  onReorder: _onReorder,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final contenedor = _contenedoresRuta[index];
                    final title = contenedor.nombreContenedor ?? 'Contenedor ${contenedor.idContenedor}';
                    return Dismissible(
                      key: ValueKey('dismiss_${contenedor.idContenedor}'),
                      direction: DismissDirection.horizontal,
                      background: _dismissBg(Alignment.centerLeft),
                      secondaryBackground: _dismissBg(Alignment.centerRight),
                      onDismissed: (_) => _onDismiss(contenedor),
                      child: AddressListItem(
                        key: ValueKey(contenedor.idContenedor),
                        title: title,
                        dragHandle: ReorderableDragStartListener(
                          index: index,
                          child: const _HandleIcon(),
                        ),
                      ),
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
