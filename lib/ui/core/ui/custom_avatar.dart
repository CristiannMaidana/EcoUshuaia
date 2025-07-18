import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAvatar extends StatefulWidget {
  final FocusNode focusNode;
  final double size;

  const CustomAvatar({
    Key? key,
    required this.focusNode,
    this.size = 40,
  }) : super(key: key);

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> with SingleTickerProviderStateMixin {
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
      'assets/lottie/avatar.json',
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