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

}