import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomEmailValidate extends StatefulWidget{
  final double size;

  const CustomEmailValidate({
    Key ? key,
    this.size = 5,

  }) : super(key: key);

  @override
  State<CustomEmailValidate> createState() => _CustomEmailValidate();
}

class _CustomEmailValidate extends State<CustomEmailValidate> with SingleTickerProviderStateMixin{
  
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/email_acept.json',
      width: widget.size,
      height: widget.size,
      repeat: false,
    );
  }
}