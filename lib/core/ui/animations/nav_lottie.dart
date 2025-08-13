import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLottiesNav extends StatelessWidget {
  final double size;
  final String nombreInicio;
  final String nombreTouch;
  final AnimationController controller;
  final bool isTouched;

  const CustomLottiesNav({
    Key? key,
    required this.size,
    required this.nombreInicio,
    required this.nombreTouch,
    required this.controller,
    required this.isTouched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      isTouched ? nombreTouch : nombreInicio,
      width: isTouched? size : 29,
      height: isTouched? size : 29,
      repeat: false,
      animate: true,
      fit: BoxFit.contain,
      controller: controller,
      onLoaded: (composition) {
        controller.duration = composition.duration;
        controller.forward(from: 0);
      },
    );
  }
}