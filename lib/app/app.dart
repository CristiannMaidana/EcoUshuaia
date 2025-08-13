import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoUshuaia',
      theme: appTheme,
      home: ContainerHomeScreen(),
    );
  }
}
