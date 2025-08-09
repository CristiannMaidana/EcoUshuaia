import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/features/home_pages/mapa/screens_mapa/contenedores_screen.dart';
import 'package:eco_ushuaia/ui/features/home_pages/mapa/screens_mapa/mapa_screen.dart';
import 'package:flutter/material.dart';

class ContainerMapaScreen extends StatefulWidget{

  @override
  State<ContainerMapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<ContainerMapaScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: camarone400,
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey[600],
            isScrollable: false,
            labelStyle: Theme.of(context).textTheme.labelLarge,
            tabs: const [
              Tab(text: 'Contenedores'),
              Tab(text: 'Mapa'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContenedoresScreen(),
            MapaScreen(),
          ],
        ),
      ),
    );
  }
}