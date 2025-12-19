import 'package:eco_ushuaia/features/map/presentation/screens/mapa_screen.dart';
import 'package:flutter/material.dart';

class ContainerMapaScreen extends StatefulWidget{
  const ContainerMapaScreen({super.key});

  @override
  State<ContainerMapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<ContainerMapaScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(context){
    return Scaffold(
        body: MapaScreen(),
    );
  }
}