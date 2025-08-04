import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_calendario.dart';
import 'package:flutter/material.dart';

class CalenderScreen extends StatefulWidget{
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Calendario', style: Theme.of(context).textTheme.bodyLarge),
              Text('12/32/32: título ', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: BotonEstandar(
              texto: 'Recordatorio',
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            calendario,
          ],
        ),
      ),
    );
  }
}