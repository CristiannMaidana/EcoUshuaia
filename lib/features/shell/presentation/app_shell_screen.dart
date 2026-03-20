import 'package:eco_ushuaia/core/ui/navigation/buttom_nav_bar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/calendar_screen.dart';
import 'package:eco_ushuaia/features/home/presentation/home_screen.dart';
import 'package:eco_ushuaia/features/map/presentation/container_mapa_screen.dart';
import 'package:eco_ushuaia/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';

class ContainerHomeScreen extends StatefulWidget{
  final int initialIndex;

  const ContainerHomeScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<ContainerHomeScreen> createState() => _ContainerHomeScreenState();
}

class _ContainerHomeScreenState extends State<ContainerHomeScreen>{
  late int _selectedIndex;
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;
  late final List<bool> _loadedTabs;
  final List<WidgetBuilder> _pageBuilders = [
    (_) => HomeScreen(),
    (_) => CalenderScreen(),
    (_) => ContainerMapaScreen(),
    (_) => SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _navigatorKeys = List.generate(_pageBuilders.length, (_) => GlobalKey<NavigatorState>());
    _loadedTabs = List.generate(_pageBuilders.length, (index) => index == _selectedIndex);
  }

  Widget _buildTabNavigator(int index) {
    if (!_loadedTabs[index]) {
      return const SizedBox.shrink();
    }

    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: _pageBuilders[index],
          settings: settings,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_pageBuilders.length, _buildTabNavigator),
      ),
      bottomNavigationBar: ButtomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (idx) {
          if (idx == _selectedIndex) {
            _navigatorKeys[idx].currentState?.popUntil((route) => route.isFirst);
            return;
          }

          setState(() {
            _selectedIndex = idx;
            _loadedTabs[idx] = true;
          });
        }
      ),
    );
  }
}
