import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomSunNight extends StatefulWidget{
  final double size;

  const CustomSunNight({
    Key ? key,
    this.size = 36,
  }): super (key: key);

  @override
  State<CustomSunNight> createState() => _CustomSunNightState();
}

class _CustomSunNightState extends State<CustomSunNight> with SingleTickerProviderStateMixin{

  @override
  Widget build(context) {
    return GestureDetector(
      child: Lottie.asset(
        'assets/lottie/sun_night.json',
        height: widget.size,
        width: widget.size,
        animate: false
      ),
    );
  }
}