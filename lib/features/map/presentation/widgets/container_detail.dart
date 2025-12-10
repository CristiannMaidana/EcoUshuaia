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
              )
            );
          },
        )
      ],
    );
  }
}