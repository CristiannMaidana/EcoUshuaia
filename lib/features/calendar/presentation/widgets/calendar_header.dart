import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.title,
    required this.onTapTitle,
    required this.onToday,
    required this.onPrev,
    required this.onNext,
    this.onFilter,
    this.onNotifications,
    this.leftInsetTitle = 30.0,
    this.filterKey,
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
  final VoidCallback? onFilter;
  final VoidCallback? onNotifications;

  final double leftInsetTitle;

  final Key? filterKey;

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
                  IconButton(icon: const Icon(Icons.notifications), onPressed: onNotifications),
                  TextButton(
                    onPressed: onFilter,
                    child: Container(
                      key: filterKey,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: _Decoration(context),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_calendar_sharp, color: Colors.black),
                          const SizedBox(width: 5),
                          Text('Filtro', style: textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ),
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
