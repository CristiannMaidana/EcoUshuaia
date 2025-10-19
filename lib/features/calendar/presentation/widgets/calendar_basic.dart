import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay = DateTime.utc(2024, 1, 1);
  final DateTime _lastDay = DateTime.utc(2026, 1, 1);

  bool _monthSeleceted = false;
  late int _yearSelected;

  @override
  void initState() {
    super.initState();
    _yearSelected = _focusedDay.year;
  }

  void _goPrevMonth() {
    if (_isMonthDisabled(_focusedDay.year, _focusedDay.month - 1)) {
      return;
    }
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    });
  }

  void _goNextMonth() {
    if (_isMonthDisabled(_focusedDay.year, _focusedDay.month + 1)) {
      return;
    }
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
  }

  bool _isMonthDisabled(int year, int month) {
    final firstOfMonth = DateTime(year, month, 1);
    final lastOfMonth  = DateTime(year, month + 1, 0); // día 0 del sig. mes = último día del mes
    return lastOfMonth.isBefore(_firstDay) || firstOfMonth.isAfter(_lastDay);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _goPrevMonth,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _goNextMonth,
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      _yearSelected = _focusedDay.year;
                      _monthSeleceted = true;
                    }), 
                    icon: const Icon(Icons.calendar_month)
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: TableCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
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
                  headerPadding: EdgeInsets.only(bottom: 10, top: 0, left: 30),
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
              ),
            )
          ],
        ),

        if (_monthSeleceted)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _monthSeleceted = false),
            ),
          ),

        if (_monthSeleceted)
          Center(
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Año anterior',
                            onPressed: () => setState(() => _yearSelected--),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Expanded(
                            child: Text(
                              '$_yearSelected',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Año siguiente',
                            onPressed: () => setState(() => _yearSelected++),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 12,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.6,
                        ),
                        itemBuilder: (context, index) {
                          final month = index + 1;
                          final date   = DateTime(_yearSelected, month, 1);
                          final label  = DateFormat.MMM(locale).format(date).toUpperCase();
                          final isCurrentFocused = (_focusedDay.year == _yearSelected && _focusedDay.month == month);
                          final disabled = _isMonthDisabled(_yearSelected, month);

                          return OutlinedButton(
                            onPressed: disabled
                                ? null
                                : () {
                                    setState(() {
                                      _focusedDay = DateTime(_yearSelected, month, 1);
                                      _selectedDay = DateTime(_yearSelected, month, 1);
                                      _monthSeleceted = false;
                                    });
                                  },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isCurrentFocused
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontWeight: isCurrentFocused ? FontWeight.w600 : FontWeight.w400,
                                color: disabled ? Colors.grey : null,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _monthSeleceted = false),
                          child: const Text('Cerrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}