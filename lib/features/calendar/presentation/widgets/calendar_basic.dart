import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 1, 1),
      focusedDay: _focusedDay,

      calendarFormat: _format,
      availableGestures: AvailableGestures.all,
      startingDayOfWeek: StartingDayOfWeek.monday,

      // Selección de día
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; 
        });
      },

      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },

      // Toggle de formato (Mes / 2 semanas / Semana)
      onFormatChanged: (format) {
        if (_format != format) {
          setState(() => _format = format);
        }
      },

      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true,
      ),
    );
  }
}