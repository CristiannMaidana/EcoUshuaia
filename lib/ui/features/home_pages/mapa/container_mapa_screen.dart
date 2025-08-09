import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class MapaScreen extends StatefulWidget{

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: camarone50,
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
        body: const TabBarView(
          children: [
            Center(child: Text('Contenedores')),
            Center(child: Text('Mapa')),
          ],
        ),
      ),
    );
  }
}