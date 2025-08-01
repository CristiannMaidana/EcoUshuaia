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
  late final AnimationController _controller;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _touched = true;    
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(context){
    return GestureDetector(
      onTap: _handleTap,
      child: Lottie.asset(
        _touched ? 'assets/lottie/settings_hover_pinch.json' : 'assets/lottie/settings_in_reveal.json',
        width: widget.size,
        height: widget.size,
        repeat: false,
        controller: _controller,
        onLoaded: (composite) {
          _controller.duration = composite.duration;
          _controller.forward(from: 0);
        } 
      ),
    );
  }
}