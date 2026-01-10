import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/detalle_ruta.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/slider_custom.dart';
import 'package:eco_ushuaia/features/prueba.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddress extends StatefulWidget {
  const SheetAddress({super.key});

  @override
  State<SheetAddress> createState() => SheetAddressState();
}

class SheetAddressState extends State<SheetAddress> {
  FlotanteSheetState? get _sheet =>
      context.findAncestorStateOfType<FlotanteSheetState>();

  bool botonPrincipal = true;
  bool botonSeleccionado = true;
  //TODO: cambiar por un metodo para obtener las coordendas de la direccion buscada
  static const double _addressLon = -68.33839;
  static const double _addressLat = -54.82707;
  final List<String> _addresses = <String>[
    'Intendente Miguel Torelli 723',
    'San Martín 123',
    'Av. Maipú 1001',
    'Héroes de Malvinas 2500',
  ];

  int _counter = 0;

  /// Mantiene SIEMPRE el orden de los strings
  final ValueNotifier<List<String>> orderStrings = ValueNotifier<List<String>>(
    <String>[],
  );

  //==== Sincroniza el ValueNotifier con la lista actual ====//
  void _syncOrder() {
    orderStrings.value = List.unmodifiable(_addresses);
  }

  void _addAddress() {
    setState(() {
      _addresses.add('Nueva dirección ${++_counter}');
      _syncOrder();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _addresses.removeAt(oldIndex);
      _addresses.insert(newIndex, item);
      _syncOrder();
    });
  }

  void _onDismiss(String text) {
    setState(() {
      _addresses.remove(text);
      _syncOrder();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Eliminado: $text')));
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
    final vmContenedores = context.watch<ContenedorViewModel>();
    final contenedoresCercanos = vmContenedores.contenedorCercanos;

    final outlineBtnStyle = OutlinedButton.styleFrom(
      shape: const StadiumBorder(),
      side: BorderSide(color: Colors.grey.shade400),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    final primaryCTAStyle = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return SafeArea(
      top: false,
      child: Column(
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
                        onPressed: () {
                          setState(() {
                            botonPrincipal = !botonPrincipal;
                          });
                        },
                        child: botonPrincipal
                            ? const Text('Ir a esta direccion')
                            : const Text('Ver contenedores'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Separador fino
          SizedBox(width: double.infinity, child: lineDivider()),

          // ===== Controles secundarios =====
          // MODO “Ver contenedores”: Radio primero
          if (botonPrincipal)
            const SliderCustom(
              lon: _addressLon,
              lat: _addressLat,
            )
          // MODO “Ir”: selector de modo
          else
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
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                botonSeleccionado = !botonSeleccionado;
                              });
                            },
                            icon: const Icon(Icons.directions_car),
                            color: botonSeleccionado
                                ? Colors.black
                                : Colors.blue.shade300,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.directions_bike),
                            color: Colors.grey.shade700,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.directions_walk),
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: primaryCTAStyle,
                    onPressed: _addAddress,
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(width: 8),
                        Text('Agregar'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ===== Contenedores cercano / Lista de direcciones =====
          if (botonPrincipal)
            Expanded(
              child: vmContenedores.loading
                  ? const Center(child: CircularProgressIndicator())
                  : (vmContenedores.error != null)
                      ? Center(child: Text(vmContenedores.error!))
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: contenedoresCercanos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CartaDetallesRecientes(
                                contenedor: contenedoresCercanos[index],
                              ),
                            );
                          },
                        ),
            )
          else
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                scrollController: scrollController,
                itemCount: _addresses.length,
                onReorder: _onReorder,
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) {
                  final text = _addresses[index];
                  return Dismissible(
                    key: ValueKey('dismiss_$text'),
                    direction: DismissDirection.horizontal,
                    background: _dismissBg(Alignment.centerLeft),
                    secondaryBackground: _dismissBg(Alignment.centerRight),
                    onDismissed: (_) => _onDismiss(text),
                    child: AddressListItem(
                      key: ValueKey(text),
                      title: text,
                      dragHandle: ReorderableDragStartListener(
                        index: index,
                        child: const _HandleIcon(),
                      ),
                    ),
                  );
                },
              ),
            ),

          // ===== Detalle de ruta (solo en modo “Ir”) =====
          if (!botonPrincipal)
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        Icon(Icons.cancel, color: Colors.black,),
                        SizedBox(width: 8),
                        Text('Cancelar', style: Theme.of(context).textTheme.labelLarge,),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (botonPrincipal)
                    OutlinedButton(
                      style: outlineBtnStyle,
                      onPressed: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.black,),
                          const SizedBox(width: 8),
                          Text('Guardar', style: Theme.of(context).textTheme.labelLarge,),
                        ],
                      ),
                    ),
                  if (botonPrincipal) const SizedBox(width: 10),
                  if (botonPrincipal)
                    OutlinedButton(
                      style: outlineBtnStyle,
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.report, color: Colors.black,),
                          SizedBox(width: 8),
                          Text('Reportar', style: Theme.of(context).textTheme.labelLarge,),
                        ],
                      ),
                    ),
                ],
              ),
            ),
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
