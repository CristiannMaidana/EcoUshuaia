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

        // acciones
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  TextButton(
                    onPressed: onToday,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: _Decoration(context),
                      child: Text('Hoy', style: textTheme.labelMedium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _Decoration(BuildContext context) {
    final borderColor = Colors.grey[400]!;
    return BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: borderColor, width: 1),
    );
  }
}
