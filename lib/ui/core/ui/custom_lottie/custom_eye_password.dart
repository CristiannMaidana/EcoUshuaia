import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomEyePassword extends StatefulWidget{
  final double size;
  final bool isClosed;
  final VoidCallback onTap;

  const CustomEyePassword({
    Key? key,
    this.size = 5,
    required this.isClosed,
    required this.onTap,
  }) : super(key: key);
  
  @override
  State<CustomEyePassword> createState() => _CustomEyeState();
}

class _CustomEyeState extends State<CustomEyePassword> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // Setea el valor inicial según el estado
    _controller.value = widget.isClosed ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant CustomEyePassword oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cuando cambia el estado, actualiza la animación
    if (oldWidget.isClosed != widget.isClosed) {
      if (widget.isClosed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: widget.onTap,
      child: Lottie.asset(
        "assets/lottie/eye_password.json",
        controller: _controller,
        width: widget.size,
        height: widget.size,
        repeat: false,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        }
      )
    );
  }
}