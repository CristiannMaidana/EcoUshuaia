import 'package:eco_ushuaia/ui/core/ui/custom_ButtomNavegationBar.dart';
import 'package:eco_ushuaia/ui/features/home_pages/home/home_screen.dart';
import 'package:flutter/material.dart';

class ContainerHomeScreen extends StatefulWidget{
  ContainerHomeScreen({Key? key}) : super (key: key);

  @override
  State<ContainerHomeScreen> createState() => _ContainerHomeScreenState();
}

class _ContainerHomeScreenState extends State<ContainerHomeScreen>{
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text('Calendario')),
    Center(child: Text('Mapa')),
    Center(child: Text('Ajustes'),)
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
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