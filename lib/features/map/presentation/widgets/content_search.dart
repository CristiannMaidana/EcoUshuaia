import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';

class ContentSearch extends StatefulWidget{

  const ContentSearch({super.key});

  @override
  State<ContentSearch> createState() => ContentSearchState();
}

class ContentSearchState extends State<ContentSearch>{
  @override
  Widget build (BuildContext context){
    return Column(
      children: [
        // Seccion de favoritos
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
          child: ExpansionTileCustom(
            title: 'Favoritos',
            // TODO: generador de contenedores favoritos, en base a la base de datos
            child: CartaDetallesRecientes(),
          ),
        )
      ],
    );
  }
}