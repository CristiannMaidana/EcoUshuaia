import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomEmail extends StatefulWidget{
  final double size;
  final FocusNode focusNode;

  const CustomEmail({
    Key? key,
    this.size = 5,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<CustomEmail> createState() => _CustomEmailState();
}

class _CustomEmailState extends State<CustomEmail> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (widget.focusNode.hasFocus) {
      _controller.forward(from: 0); // Siempre se reproduce desde el principio al enfocar
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/email.json',
      controller: _controller,
      width: widget.size,
      height: widget.size,
      repeat: false,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
      },
    );
  }
}