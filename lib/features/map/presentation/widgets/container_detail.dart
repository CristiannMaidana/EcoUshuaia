import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/data_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/info_state_container.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContainerDetail extends StatefulWidget {
  Contenedor? container;

  ContainerDetail({
    Key? key,
    required this.container,
  }) : super(key: key);

  @override
  State<ContainerDetail> createState() => ContainerDetailState();
}

class ContainerDetailState extends State<ContainerDetail> {
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  void dispose() {
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
      0.57,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DraggableScrollableSheet(
          controller: _draggableController,
          initialChildSize: 0.0,
          minChildSize: 0.0,
          maxChildSize: 0.57,
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
                  physics: const NeverScrollableScrollPhysics(),
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
                              margin: const EdgeInsets.only(top: 12, bottom: 16),
                              width: 55,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
                              child: Column(
                                children: [
                                  //Titulo y acciones header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                              Text(
                                                (widget.container?.idZona ?? 'Zona ').toString(),
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                            ]
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            widget.container?.descripcionUbicacion ?? 'Dirección Desconocida',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          CircleIcon(icon: Icons.search, onPressed: () {}),
                                          SizedBox(width: 8),
                                          CircleIcon(icon: Icons.close, onPressed: _bajarSheet),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  //Informacion de contenedores
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: DataContainer(
                                          contenido: (widget.container?.residuo ?? 'Plastico').toString(),
                                          icon: Icons.circle,
                                          colorIcon: Colors.amber
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: DataContainer(
                                          contenido: (widget.container?.idContenedor ?? 'Codigo').toString(),
                                          icon: Icons.my_library_books_outlined,
                                          colorIcon: Colors.black
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: DataContainer(
                                          contenido: (widget.container?.residuo ?? '800 M').toString(),
                                          icon: Icons.location_on_outlined,
                                          colorIcon: Colors.black
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