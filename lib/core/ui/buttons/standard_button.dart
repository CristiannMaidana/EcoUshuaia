import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icono;
  //final bool expandido;
  final ButtonStyle? style;
  final double? width;
  final double? height;

  const StandardButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    //this.expandido = false,
    this.style,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = icono != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono),
              const SizedBox(width: 8),
              Text(texto),
            ],
          )
        : Text(texto);

    Widget button = ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: style,
    );

    Widget result = button;

    if (width != null || height != null) {
      result = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }// else if (expandido) {
     // result = SizedBox( child: button);
   // }

    return result;
  }
}