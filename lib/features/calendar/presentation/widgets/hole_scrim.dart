import 'package:flutter/material.dart';

/// Bloquea todo menos los rectángulos listados en [holes].
/// - Pinta y capta toques *solo* fuera de los agujeros.
/// - Los agujeros quedan "vacíos": pasan los toques al contenido detrás.
///
/// Nota: los agujeros son rectangulares. Para un botón circular,
/// pasá su bounding box (el rect del IconButton).
class HoleScrim extends StatelessWidget {
  final List<Rect> holes;
  final Color color;
  final VoidCallback onTapOutside;

  const HoleScrim({
    super.key,
    required this.holes,
    required this.color,
    required this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // 1) Cortes en ejes a partir de bordes de agujeros
        final xs = <double>{0, w}..addAll(holes.expand((r) => [r.left, r.right]));
        final ys = <double>{0, h}..addAll(holes.expand((r) => [r.top, r.bottom]));
        final xCuts = xs.toList()..sort();
        final yCuts = ys.toList()..sort();

        // 2) Para cada celda del grid, si no cae *dentro* de un agujero, se pinta/captura
        List<Widget> blocks = [];
        for (var i = 0; i < xCuts.length - 1; i++) {
          for (var j = 0; j < yCuts.length - 1; j++) {
            final rect = Rect.fromLTWH(
              xCuts[i],
              yCuts[j],
              xCuts[i + 1] - xCuts[i],
              yCuts[j + 1] - yCuts[j],
            );
            if (rect.isEmpty) continue;

            final insideAnyHole = holes.any((hole) =>
                rect.left >= hole.left &&
                rect.right <= hole.right &&
                rect.top >= hole.top &&
                rect.bottom <= hole.bottom);

            if (!insideAnyHole) {
              blocks.add(Positioned(
                left: rect.left,
                top: rect.top,
                width: rect.width,
                height: rect.height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTapOutside,
                  child: ColoredBox(color: color),
                ),
              ));
            }
          }
        }

        return Stack(children: blocks);
      },
    );
  }
}
