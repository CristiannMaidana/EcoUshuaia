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

  @override
  Widget build(context){
    return Container();
  }
}