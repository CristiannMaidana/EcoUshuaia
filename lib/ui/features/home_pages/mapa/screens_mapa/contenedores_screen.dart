import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class ContenedoresScreen extends StatefulWidget{

  ContenedoresScreen({
    Key ? Key,
  }): super (key: Key);

  @override
  State<ContenedoresScreen> createState() => _ContendoresScreenState();
}

class _ContendoresScreenState extends State<ContenedoresScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
    );
  }
}