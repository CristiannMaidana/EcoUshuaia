import 'package:flutter/material.dart';

class BuildCalenderScreen extends StatefulWidget{
  @override
  State<BuildCalenderScreen> createState() => _BuildCalenderScreenState();
}

class _BuildCalenderScreenState extends State<BuildCalenderScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: Center(
      ),
    );
  }
}