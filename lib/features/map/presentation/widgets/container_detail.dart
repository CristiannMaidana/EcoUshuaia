import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/data_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/info_state_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ContainerDetail extends StatefulWidget {
  Contenedor? container;
  final Future<double>? Function(double lat, double lon)? distancia;

  ContainerDetail({
    Key? key,
    required this.container,
    this.distancia,
  }) : super(key: key);

  @override
  State<ContainerDetail> createState() => ContainerDetailState();
}

class ContainerDetailState extends State<ContainerDetail> {
  late DraggableScrollableController _draggableController;
  Future<double>? _metrosFuture;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController()..addListener(_onSheetChange);
    _updateMetrosFuture();
  }

  @override
  void didUpdateWidget(covariant ContainerDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCoord = oldWidget.container?.coordenada;
    final newCoord = widget.container?.coordenada;
    final coordsChanged = oldCoord?.latitud != newCoord?.latitud ||
        oldCoord?.longitud != newCoord?.longitud;
    if (coordsChanged || oldWidget.distancia != widget.distancia) {
      _updateMetrosFuture();
    }
  }

  void _updateMetrosFuture() {
    final fn = widget.distancia;
    final coord = widget.container?.coordenada;
    if (fn == null || coord == null) {
      _metrosFuture = null;
      return;
    }
    _metrosFuture = fn(coord.latitud, coord.longitud);
  }

  String _formatDistance(double meters) {
    if (meters.isNaN || meters.isInfinite) return '';
    if (meters < 1000) return '${meters.round()} M';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} KM';
  }

  // Listener para el cambio de tamaño del sheet
  void _onSheetChange() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _draggableController.removeListener(_onSheetChange);
    _draggableController.dispose();
    super.dispose();
  }

  void _bajarSheet() {
    _draggableController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void subirSheet() {
    _draggableController.animateTo(
      0.49,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool get isExpanded {
    if (!_draggableController.isAttached) return false;
    return _draggableController.size > 0 + 0.001;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResiduoViewmodel>();
    final vmMap = context.watch<MapSearchViewModel>();

    final idResiduo = widget.container?.idResiduo;
    final Residuos? residuo = (idResiduo == null) ? null : vm.getResiduo(idResiduo);
    final String direccion = vmMap.getDireccionFromPoint(
      widget.container?.coordenada?.latitud,
      widget.container?.coordenada?.longitud,);
      
    return Stack(
      fit: StackFit.expand,
      children: [
        // Para cerrar el sheet si toca afuera 
        if (isExpanded)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _bajarSheet,
            child: const SizedBox.expand(),
          ),

        DraggableScrollableSheet(
          controller: _draggableController,
          initialChildSize: 0.0,
          minChildSize: 0.0,
          maxChildSize: 0.49,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!, width: 1)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            )
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: BarraAgarre(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
                              child: Column(
                                children: [
                                  //Titulo detalle simple de contenedor
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.2),
                                              borderRadius: BorderRadius.all(Radius.circular(16)),
                                            ),
                                            child: Icon(Icons.location_on_outlined, size: 40, color: Colors.green,)
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.container?.nombreContenedor ?? 'Contenedor numero',
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  Text(' . ', style: Theme.of(context).textTheme.titleMedium),
                                                  Text((widget.container?.idZona ?? 'Zona ').toString(),
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                ]
                                              ),
                                              SizedBox(height: 4),
                                              // Text(
                                              //   'Dirección: $direccion',
                                              //   style: Theme.of(context).textTheme.bodyMedium,
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      CircleIcon(icon: Icons.close, onPressed: _bajarSheet), 
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  
                                  //Informacion de contenedores
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: DataContainer(
                                          contenido: residuo?.nombre ?? 'Desconocido',
                                          icon: Icons.circle,
                                          colorIcon: residuo == null ? Colors.grey : residuo.colorHex.toColor(),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        child: DataContainer(
                                          contenido: (widget.container?.idContenedor).toString(),
                                          icon: Icons.my_library_books_outlined,
                                          colorIcon: Colors.black
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        child: FutureBuilder<double>(
                                          future: _metrosFuture,
                                          builder: (context, snap) {
                                            final text = snap.hasData
                                                ? _formatDistance(snap.data!)
                                                : '';
                                            return DataContainer(
                                              contenido: text,
                                              icon: Icons.location_on_outlined,
                                              colorIcon: Colors.black,
                                            );
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                  SizedBox(height: 16),
                                  //Informacion de estado de contenedor
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Capacidad de vaciado',
                                          descripcion: (widget.container?.capacidadTotal ?? 'Desconocido').toString(),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Próx. recolección',
                                          descripcion: (widget.container?.capacidadTotal ?? 'Desconocido').toString(),
                                        ),
                                      ),
                                    ]
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Nivel de llenado',
                                          descripcion: (widget.container?.capacidadTotal ?? 'Desconocido').toString(),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Estado',
                                          descripcion: (widget.container?.capacidadTotal ?? 'Desconocido').toString(),
                                        ),
                                      ),
                                    ]
                                  ),
                                  //Botones de accion
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          minimumSize: const Size(0, 52),
                                        ),
                                        onPressed: () {}, 
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.notifications_none, color: Colors.black, size: 24),
                                            const SizedBox(width: 6),
                                            Text('Recordarme', style: Theme.of(context).textTheme.labelLarge),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.map_outlined, color: Colors.black, size: 24),
                                            const SizedBox(width: 6),
                                            Text('Navegar', style: Theme.of(context).textTheme.labelLarge),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            );
          },
        )
      ],
    );
  }
}
