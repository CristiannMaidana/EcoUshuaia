import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomMapa extends StatefulWidget{
  final double size;

  const CustomMapa({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State <CustomMapa> createState() => _CustomMapState ();
}

class _CustomMapState extends State<CustomMapa> with SingleTickerProviderStateMixin{
  bool _touched = false;

  void _handleTap() {
    setState(() {
      _touched = true;
    });
  }

  @override
  Widget build(context){
    return GestureDetector(
      onTap: _handleTap,
      child: Lottie.asset(
        _touched ? 'assets/lottie/mapa_in_reveal.json' 
        : 'assets/lottie/mapa_hover_pinch.json',
        animate: false,
        width: widget.size,
        height: widget.size, 
      ),
    );
  }
}