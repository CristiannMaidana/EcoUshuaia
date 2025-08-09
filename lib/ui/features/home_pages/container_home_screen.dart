import 'package:eco_ushuaia/ui/core/ui/custom_ButtomNavegationBar.dart';
import 'package:eco_ushuaia/ui/features/home_pages/calender/calender_screen.dart';
import 'package:eco_ushuaia/ui/features/home_pages/home/home_screen.dart';
import 'package:eco_ushuaia/ui/features/home_pages/mapa/container_mapa_screen.dart';
import 'package:eco_ushuaia/ui/features/home_pages/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class ContainerHomeScreen extends StatefulWidget{
  final int initialIndex;

  ContainerHomeScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super (key: key);

  @override
  State<ContainerHomeScreen> createState() => _ContainerHomeScreenState();
}

class _ContainerHomeScreenState extends State<ContainerHomeScreen>{
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomeScreen(),
    CalenderScreen(),
    ContainerMapaScreen(),
    SettingsScreen(),
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