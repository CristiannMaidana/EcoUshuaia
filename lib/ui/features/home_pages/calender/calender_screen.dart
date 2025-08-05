import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_calendario.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_novedades.dart';
import 'package:flutter/material.dart';

class CalenderScreen extends StatefulWidget{
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> with SingleTickerProviderStateMixin {
  bool _cambioAnuncios = true;

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
              texto: _cambioAnuncios? 'Recordatorio' : 'Novedades',
              onPressed: () {
                setState(() {
                  _cambioAnuncios = !_cambioAnuncios;
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            height: 392,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey[400]!, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: calendario,
          ),
            CustomNovedades(),
        ],
      ),
    );
  }
}