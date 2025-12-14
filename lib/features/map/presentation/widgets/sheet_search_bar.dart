import 'package:flutter/material.dart';

class SheetSearchBar extends StatefulWidget{
  Widget nav_bar;

  SheetSearchBar({
    Key? key,
    required this.nav_bar,
  }) :super(key: key);

  @override
  State<SheetSearchBar> createState() => _SheetSearchBarState();
}

class _SheetSearchBarState extends State<SheetSearchBar>{

  @override
  Widget build (BuildContext context){
    return Stack();
  }
}