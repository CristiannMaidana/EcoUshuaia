import 'package:eco_ushuaia/ui/core/ui/custom_mapa.dart';
import 'package:flutter/material.dart';

class MapaScreen extends StatefulWidget{

  MapaScreen({
    Key? key,
  }): super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          border: Border.all(width: 1)
        ),
        child: CustomMapa()
      ),
    );
  }
}