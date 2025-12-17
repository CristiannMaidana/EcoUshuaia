import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ContentFilter extends StatefulWidget {
  const ContentFilter({super.key});

  @override
  State<ContentFilter> createState() => _ContentFilterState();
}

class _ContentFilterState extends State<ContentFilter> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: camarone100,
      child: Column(
        children: [
          // TODO: padding con hijo ExpansionTileCustom para la seleccion de tipo de residuos
            
          // TODO: padding con hijo ExpansionTileCustom para la seleccion de estado del contenedor

          // TODO: padding con hijo ExpansionTileCustom para la seleccion de dias de recoleccion

          // TODO: padding con hijo ExpansionTileCustom para la seleccion de nivel de llenado del contenedor
        ],
      ),
    );
  }
}
