import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNotification extends StatefulWidget {
  final double size;
  final List notificaciones;

  const CustomNotification({
    Key? key,
    this.size = 60,
    required this.notificaciones,
  }) : super(key: key);

  @override
  State<CustomNotification> createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _touched = true;
    });
    _controller.forward(from: 0);
    //Aca debería colocar el overlay para los mensajes de las notificaciones
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Lottie.asset(
        _touched
            ? 'assets/lottie/notification_hover_ring.json'
            : 'assets/lottie/notification_reveal.json',
        controller: _controller,
        width: widget.size,
        height: widget.size,
        repeat: false,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _controller.forward(from: 0);
        },
      ),
    );
  }
}