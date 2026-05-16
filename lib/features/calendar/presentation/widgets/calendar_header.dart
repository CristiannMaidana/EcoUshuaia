import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.title,
    required this.onTapTitle,
    required this.onToday,
    required this.onPrev,
    required this.onNext,
    this.onNotifications,
    this.leftInsetTitle = 30.0,
  });

  /// Texto del mes 
  final String title;

  /// Tocar el título
  final VoidCallback onTapTitle;

  /// Botón "Hoy"
  final VoidCallback onToday;

  /// Chevrons de navegación
  final VoidCallback onPrev;
  final VoidCallback onNext;

  /// Acciones de la derecha
  final VoidCallback? onNotifications;

  final double leftInsetTitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // seleccion mes + chevrons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: onTapTitle,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: leftInsetTitle),
                      child: Text(title, 
                        textAlign: TextAlign.start, 
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 22, 
                          fontWeight: FontWeight.w700, 
                          color: const Color(0xFF111827)
                        )
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.chevron_left, size: 30), onPressed: onPrev),
                  IconButton(icon: const Icon(Icons.chevron_right, size: 30), onPressed: onNext),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
