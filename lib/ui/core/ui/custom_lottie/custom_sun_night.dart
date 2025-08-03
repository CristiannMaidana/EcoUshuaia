import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomSunNight extends StatefulWidget{
  final double size;
  final bool modoNoche;

  const CustomSunNight({
    Key ? key,
    this.size = 36,
    required this.modoNoche,
  }): super (key: key);

  @override
  State<CustomSunNight> createState() => _CustomSunNightState();
}

class _CustomSunNightState extends State<CustomSunNight> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void didUpdateWidget(covariant CustomSunNight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modoNoche != widget.modoNoche) {
      if (widget.modoNoche) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse(from: 1);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.value = widget.modoNoche ? 1 : 0;
    });
    }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return GestureDetector(
      child: Lottie.asset(
        'assets/lottie/sun_night.json',
        height: widget.size,
        width: widget.size,
        animate: false,
        controller: _controller,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        } 
      ),
    );
  }
}