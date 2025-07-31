import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNotification extends StatefulWidget{
  final double size;
  final FocusNode focusNode;

  const CustomNotification({
    Key? key,
    this.size = 70,
    required this.focusNode,
  }) : super(key: key);

  @override
  State <CustomNotification> createState() => _CustomEmailState();
}

class _CustomEmailState extends State<CustomNotification> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  Widget build (contexto){
    return Lottie.asset(
      'assets/lottie/notification_reveal.json',
      width: widget.size,
      height: widget.size,
      repeat: false,
    );
  }
}