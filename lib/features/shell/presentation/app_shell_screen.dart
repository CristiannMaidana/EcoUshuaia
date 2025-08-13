import 'package:eco_ushuaia/core/ui/navigation/buttom_nav_bar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/calendar_screen.dart';
import 'package:eco_ushuaia/features/home/presentation/home_screen.dart';
import 'package:eco_ushuaia/features/map/presentation/container_mapa_screen.dart';
import 'package:eco_ushuaia/features/settings/presentation/settings_screen.dart';
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
      bottomNavigationBar: ButtomNavBar(
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