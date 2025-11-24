import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  // Ancla y overlay para el panel de Filtro
  final LayerLink _filterLink = LayerLink();
  final GlobalKey _filterBtnKey = GlobalKey();
  OverlayEntry? _filterEntry;

  @override
  void initState() {
    super.initState();
    _yearSelected = _focusedDay.year;
  }

  void _goPrevMonth() {
    if (_isMonthDisabled(_focusedDay.year, _focusedDay.month - 1)) return;
    setState(() => _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1));
    context.read<CalendarioViewmodel>().setSelectedDay(null);
    context.read<CalendarioViewmodel>().setVisibleMonth(_focusedDay);
  }

  void _goNextMonth() {
    if (_isMonthDisabled(_focusedDay.year, _focusedDay.month + 1)) return;
    setState(() => _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1));
    context.read<CalendarioViewmodel>().setSelectedDay(null);
    context.read<CalendarioViewmodel>().setVisibleMonth(_focusedDay);
  }

  bool _isMonthDisabled(int year, int month) {
    final firstOfMonth = DateTime(year, month, 1);
    final lastOfMonth  = DateTime(year, month + 1, 0);
    return lastOfMonth.isBefore(_firstDay) || firstOfMonth.isAfter(_lastDay);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final vm = context.watch<CalendarioViewmodel>();
    final titulo = DateFormat.yMMMM(locale).format(_focusedDay);
    
    return Stack(
      children: [
        Column(
          children: [
            CalendarHeader(
              title: titulo,
              onTapTitle: () => setState(() {
                _yearSelected = _focusedDay.year;
                _monthSeleceted = true;
              }),
              onToday: () {
                setState(() {
                  _focusedDay = DateTime.now();
                  _selectedDay = null;
                });
                final vm = context.read<CalendarioViewmodel>();
                vm.setVisibleMonth(_focusedDay);
                vm.setSelectedDay(null);
              },
              onPrev: _goPrevMonth,
              onNext: _goNextMonth,
              // Metodo boton 
              onFilter: (){},
              // Ancla para el overlay
              filterAnchor: _filterLink,
              // Key del botón filtro
              filterKey: _filterBtnKey,

              onNotifications: () {
                // TODO: acción de notificaciones
              },
            ),

            Expanded(
              child: Calendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                format: _format,
                rowHeight: 50,
                headerVisible: false,
                onDaySelected: (sel, foc) {
                  setState(() {
                    _selectedDay = sel;
                    _focusedDay = foc;
                  });
                  context.read<CalendarioViewmodel>().setSelectedDay(sel);
                },
                onPageChanged: (foc) {
                  _focusedDay = foc;
                  context.read<CalendarioViewmodel>().setVisibleMonth(foc);
                },
                onFormatChanged: (fmt) {
                  if (_format != fmt) setState(() => _format = fmt);
                },
                eventLoader: vm.eventsOf,
                hasEvents: vm.hasEvents,
              ),
            ),
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
                          final date  = DateTime(_yearSelected, month, 1);
                          final label = DateFormat.MMM(locale).format(date).toUpperCase();
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