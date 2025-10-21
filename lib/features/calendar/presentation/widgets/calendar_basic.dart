import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';

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
    context.read<CalendarioViewmodel>().setSelectedDay(null);
    context.read<CalendarioViewmodel>().setVisibleMonth(_focusedDay);
  }

  void _goNextMonth() {
    if (_isMonthDisabled(_focusedDay.year, _focusedDay.month + 1)) {
      return;
    }
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
    context.read<CalendarioViewmodel>().setSelectedDay(null);
    context.read<CalendarioViewmodel>().setVisibleMonth(_focusedDay);
  }

  bool _isMonthDisabled(int year, int month) {
    final firstOfMonth = DateTime(year, month, 1);
    final lastOfMonth  = DateTime(year, month + 1, 0); // día 0 del sig. mes = último día del mes
    return lastOfMonth.isBefore(_firstDay) || firstOfMonth.isAfter(_lastDay);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final vm = context.watch<CalendarioViewmodel>();

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
              child: TableCalendar<Calendarios>(
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
                  context.read<CalendarioViewmodel>().setSelectedDay(selectedDay);
                },
              
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  context.read<CalendarioViewmodel>().setVisibleMonth(focusedDay);
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

                eventLoader: vm.eventsOf,                                            
                calendarBuilders: CalendarBuilders<Calendarios>(
                  defaultBuilder: (context, day, focusedDay) {
                    if (!vm.hasEvents(day)) return null;                             
                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F5EA),                              
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {                         
                    final has = vm.hasEvents(day);
                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: has ? const Color(0xFFDBECFF) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {                  
                    final has = vm.hasEvents(day);
                    final base = Theme.of(context).colorScheme.primary;
                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: has ? base.withOpacity(0.18) : base.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: base, width: 1.6),
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}', style: TextStyle(fontWeight: FontWeight.w700, color: base)),
                    );
                  },
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
                                    final vm = context.read<CalendarioViewmodel>();
                                    vm.setVisibleMonth(_focusedDay);
                                    vm.setSelectedDay(_selectedDay);
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