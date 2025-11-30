import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.selectedDay,
    required this.format,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onFormatChanged,
    required this.eventLoader,
    required this.hasEvents,
    this.rowHeight = 50,
    this.headerVisible = false,
    this.startingDayOfWeek = StartingDayOfWeek.monday,
    this.availableGestures = AvailableGestures.all,
    this.cellMargin = const EdgeInsets.all(6),
  });

  // Rango y estado
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat format;

  // Callbacks
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged;
  final void Function(CalendarFormat format) onFormatChanged;

  // Datos
  final List<Calendarios> Function(DateTime day) eventLoader;
  final bool Function(DateTime day) hasEvents;

  // Estilos
  final double rowHeight;
  final bool headerVisible;
  final StartingDayOfWeek startingDayOfWeek;
  final AvailableGestures availableGestures;
  final EdgeInsets cellMargin;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return TableCalendar<Calendarios>(
      locale: locale,
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,

      calendarFormat: format,
      onFormatChanged: onFormatChanged,

      availableGestures: availableGestures,
      startingDayOfWeek: startingDayOfWeek,
      headerVisible: headerVisible,
      rowHeight: rowHeight,

      // Selección
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,

      // Eventos
      eventLoader: eventLoader,

      calendarBuilders: CalendarBuilders<Calendarios>(
        defaultBuilder: (context, day, focusedDay) {
          final evs = eventLoader(day);
          final has = evs.isNotEmpty;

          return _dayCell(
            context,
            day,
            bgColor: has ? (const Color(0xFFE6F5EA)).withOpacity(0.18) : null,
            margin: cellMargin,
          );
        },
        todayBuilder: (context, day, focusedDay) {
          final base = Theme.of(context).colorScheme.primary;
          return _dayCell(
            context,
            day,
            bgColor: base.withOpacity(0.22),
            border: Border.all(color: base, width: 1.2),
            margin: cellMargin,
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          final base = Theme.of(context).colorScheme.primary;
          return _dayCell(
            context,
            day,
            bgColor: base.withOpacity(0.28),
            border: Border.all(color: base, width: 1.6),
            textColor: base,
            fontWeight: FontWeight.w700,
            margin: cellMargin,
          );
        },

        // Generacion de circulos de colores para eventos
        markerBuilder: (context, day, events) {
          final evs = events.cast<Calendarios>();
          if (evs.isEmpty) return const SizedBox.shrink();

          final cats = context.watch<CategoriaNoticiasViewmodel>();
          
          final colors = evs
              .map((e) => cats.colorFor(e.categoriaNoticiaId) ?? Colors.grey)
              .toList();

          // Limite de 5 colores a mostrar
          final show = colors.take(5).toList();

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: show
                  .map((c) => Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _dayCell(
    BuildContext context,
    DateTime day, {
    Color? bgColor,
    Color? textColor,
    BoxBorder? border,
    FontWeight fontWeight = FontWeight.w600,
    EdgeInsets margin = const EdgeInsets.all(6),
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: fontWeight,
          color: textColor ?? Colors.black87,
        ),
      ),
    );
  }
}