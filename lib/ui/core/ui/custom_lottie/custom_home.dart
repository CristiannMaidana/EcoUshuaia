import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomHome extends StatefulWidget{
  final double size;

  const CustomHome({
    Key ? key,
    required this.size
  }) : super (key: key);

  @override
  State<CustomHome> createState() => _CustomHomeState();
}

class _CustomHomeState extends State<CustomHome> with SingleTickerProviderStateMixin{

  @override
  Widget build(context) {
    return GestureDetector();
  }
}