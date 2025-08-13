import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/screens/contenedores_screen.dart';
import 'package:eco_ushuaia/features/map/presentation/screens/mapa_screen.dart';
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