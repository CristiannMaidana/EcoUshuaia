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
        _touched ? 'assets/lottie/mapa_hover_pinch.json'
        : 'assets/lottie/mapa_in_reveal.json',
        controller: _controller,
        repeat: false,
        width: widget.size,
        height: widget.size,
        onLoaded: (composite) {
          _controller.duration = composite.duration;
          _controller.forward(from: 0);
        }
      ),
    );
  }
}