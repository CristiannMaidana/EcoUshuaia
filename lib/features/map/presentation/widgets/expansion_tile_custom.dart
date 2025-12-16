import 'package:flutter/material.dart';

class ExpansionTileCustom extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyOpen;

  const ExpansionTileCustom({
    super.key, 
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  @override
  State<ExpansionTileCustom> createState() => ExpansionTileCustomState();
}

class ExpansionTileCustomState extends State<ExpansionTileCustom> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}