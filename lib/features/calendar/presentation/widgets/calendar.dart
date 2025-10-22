import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';

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

  final List<Calendarios> Function(DateTime day) eventLoader;
  final bool Function(DateTime day) hasEvents;

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
        defaultBuilder: (context, day, focused) {
          if (!hasEvents(day)) return null;
          return _dayCell(
            context,
            day,
            bgColor: const Color(0xFFE6F5EA),
            margin: cellMargin,
          );
        },
        todayBuilder: (context, day, focused) {
          final has = hasEvents(day);
          return _dayCell(
            context,
            day,
            bgColor: has ? const Color(0xFFDBECFF) : const Color(0xFFEFF6FF),
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.2),
            margin: cellMargin,
          );
        },
        selectedBuilder: (context, day, focused) {
          final has = hasEvents(day);
          final base = Theme.of(context).colorScheme.primary;
          return _dayCell(
            context,
            day,
            bgColor: has ? base.withOpacity(0.18) : base.withOpacity(0.12),
            border: Border.all(color: base, width: 1.6),
            textColor: base,
            fontWeight: FontWeight.w700,
            margin: cellMargin,
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
