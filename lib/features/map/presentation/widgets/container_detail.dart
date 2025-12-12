import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:flutter/material.dart';

class ContainerDetail extends StatefulWidget {
  final Contenedor? container;

  const ContainerDetail({
    Key? key,
    required this.container,
  }) : super(key: key);

  @override
  State<ContainerDetail> createState() => _ContainerDetailState();
}

class _ContainerDetailState extends State<ContainerDetail> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.55,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
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
                      width: 40,
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
                            ],
                          ),
                        ],
                      )
                    )
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