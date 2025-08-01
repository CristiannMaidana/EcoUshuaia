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

  @override
  Widget build(context){
    return GestureDetector();
  }
}