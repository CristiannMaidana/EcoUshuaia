import 'package:eco_ushuaia/ui/core/ui/custom_ButtomNavegationBar.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_notification.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super (key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final List listaNotificaciones=List.empty(); //Simula ser la lista de todas las notificaciones de la base de dato
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Inicio')),
    Center(child: Text('Calendario')),
    Center(child: Text('Mapa')),
    Center(child: Text('Ajustes'),)
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child:  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  width: 1
                )
              ),
              child: CustomNotification(notificaciones: listaNotificaciones)
              ),
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        }
      ),
    );
  }
}