import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomCalendario extends StatefulWidget{
  final double size;

  const CustomCalendario({
    Key ? key,
    required this.size,
  }): super(key: key);

  @override
  State<CustomCalendario> createState() => _CustomCalendarioState();
}

class _CustomCalendarioState extends State<CustomCalendario> with SingleTickerProviderStateMixin{

  @override
  Widget build(context) {
    return GestureDetector();
  }
}