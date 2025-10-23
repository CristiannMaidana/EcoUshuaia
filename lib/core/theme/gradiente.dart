import 'package:flutter/material.dart';

class Gradiente extends StatelessWidget {
  final double height;
  final BorderRadius? borderRadius;

  const Gradiente({
    super.key,
    this.height = 220,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    const baseA   = Color.fromARGB(255, 208, 242, 226); // izquierda (mint té)
    const baseB   = Color.fromARGB(255, 146, 240, 188); // derecha (verde suave, un poco más “presente”)
    const radialA = Color(0xFFE6FBF1); // realce abajo-izq
    const radialB = Color.fromARGB(95, 255, 255, 255); // realce arriba-der (reemplaza el azul por verde agua)

    Widget layer(Gradient g) => Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: g,
              borderRadius: borderRadius,
            ),
          ),
        );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // 1) Lineal base (≈120°)
            layer(const LinearGradient(
              begin: Alignment(-0.8, -0.6),
              end: Alignment(0.8, 0.6),
              colors: [baseA, baseB],
            )),
            // 2) Radial abajo-izquierda (suave)
            layer(const RadialGradient(
              center: Alignment(-0.8, 1.0), // ~10% x, 100% y
              radius: 1.2,
              colors: [radialA, Colors.transparent],
              stops: [0.0, 0.55],
            )),
            // 3) Radial arriba-derecha (toque aqua/menta)
            layer(const RadialGradient(
              center: Alignment(1.0, -0.1), // ~100% x, 0% y
              radius: 1.1,
              colors: [radialB, Colors.transparent],
              stops: [0.0, 0.45],
            )),
            // 4) Overlay oscuro mínimo para priorizar texto
            layer(LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.00),
                Colors.black.withOpacity(0.16),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
