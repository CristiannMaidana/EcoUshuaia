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
      appBar: AppBar(
        title: Text('Calendario', style: Theme.of(context).textTheme.displayLarge),
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