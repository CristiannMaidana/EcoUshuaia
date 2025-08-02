import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomChevron extends StatefulWidget{
  final double size;
  final Duration duration;
  
  const CustomChevron({
    Key ? key,
    this.size = 24,
    this.duration = const Duration(seconds: 5),
  }): super(key: key);

  @override
  State<CustomChevron> createState() => _CustomChevronState();
}

class _CustomChevronState extends State<CustomChevron> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context){
    return Lottie.asset(
      'assets/lottie/chevron_right_in_reveal.json',
      width: widget.size,
      height: widget.size,
      repeat: false,
    );
  }
}