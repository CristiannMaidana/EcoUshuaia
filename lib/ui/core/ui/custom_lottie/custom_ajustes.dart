import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAjustes extends StatefulWidget{
  final double size;

  const CustomAjustes({
    Key ? key,
    required this.size,
  }) : super(key: key);

  @override
  State <CustomAjustes> createState() => _CustomAjustesState();
}

class _CustomAjustesState extends State<CustomAjustes> with SingleTickerProviderStateMixin{
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
        _touched ? 'assets/lottie/settings_hover_pinch.json' : 'assets/lottie/settings_in_reveal.json',
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}