import 'package:flutter/material.dart';

const List<String> _abbreviatedWeekdayNames = [
  'Lun',
  'Mar',
  'Mié',
  'Jue',
  'Vie',
  'Sáb',
  'Dom',
];

const List<String> _fullWeekdayNames = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

const List<String> _abbreviatedMonthNames = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sept',
  'oct',
  'nov',
  'dic',
];

const List<String> _fullMonthNames = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

class WheelPickerOfTimeController {
  WheelPickerOfTimeController()
    : _selectedDateTime = _currentDateTimeWithoutSeconds();

  DateTime _selectedDateTime;

  DateTime get selectedDateTime => _selectedDateTime;

  String get formattedSelectedDateTime {
    final weekday = _fullWeekdayNames[_selectedDateTime.weekday - 1];
    final month = _fullMonthNames[_selectedDateTime.month - 1];
    final hour = _selectedDateTime.hour.toString().padLeft(2, '0');
    final minute = _selectedDateTime.minute.toString().padLeft(2, '0');

    return '$weekday ${_selectedDateTime.day} de $month · $hour:$minute';
  }

  void _updateSelectedDay(DateTime selectedDay) {
    _selectedDateTime = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
      _selectedDateTime.hour,
      _selectedDateTime.minute,
    );
  }

  void _updateSelectedHour(int selectedHour) {
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      selectedHour,
      _selectedDateTime.minute,
    );
  }

  void _updateSelectedMinute(int selectedMinute) {
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      _selectedDateTime.hour,
      selectedMinute,
    );
  }

  static DateTime _currentDateTimeWithoutSeconds() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }
}

class WheelPickerOfTime extends StatefulWidget {
  const WheelPickerOfTime({
    super.key,
    required this.controller,
    this.onSelectedDateTimeChanged,
  });

  final WheelPickerOfTimeController controller;
  final ValueChanged<DateTime>? onSelectedDateTimeChanged;

  @override
  State<WheelPickerOfTime> createState() => _WheelPickerOfTimeState();
}

class _WheelPickerOfTimeState extends State<WheelPickerOfTime> {
  static const double _itemExtent = 40;
  static const double _wheelHeight = _itemExtent * 4.5;

  late final DateTime _today;
  late final List<DateTime> _availableDays;
  late final FixedExtentScrollController _dayScrollController;
  late final FixedExtentScrollController _hourScrollController;
  late final FixedExtentScrollController _minuteScrollController;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _availableDays = _createAvailableDays();
    final selectedDateTime = widget.controller.selectedDateTime;
    final selectedDayIndex = _availableDays.indexWhere(
      (day) => _isSameDay(day, selectedDateTime),
    );
    final initialDayIndex = selectedDayIndex >= 0
        ? selectedDayIndex
        : _availableDays.indexWhere((day) => _isSameDay(day, _today));

    _dayScrollController = FixedExtentScrollController(
      initialItem: initialDayIndex,
    );
    _hourScrollController = FixedExtentScrollController(
      initialItem: selectedDateTime.hour,
    );
    _minuteScrollController = FixedExtentScrollController(
      initialItem: selectedDateTime.minute,
    );
  }

  List<DateTime> _createAvailableDays() {
    final startingDate = _moveDateByMonths(_today, -1);
    final endingDate = _moveDateByMonths(_today, 1);
    final numberOfDays = endingDate.difference(startingDate).inDays + 1;

    return List<DateTime>.generate(
      numberOfDays,
      (index) => startingDate.add(Duration(days: index)),
    );
  }

  DateTime _moveDateByMonths(DateTime date, int numberOfMonths) {
    final firstDayOfTargetMonth = DateTime(
      date.year,
      date.month + numberOfMonths,
    );
    final lastDayOfTargetMonth = DateTime(
      firstDayOfTargetMonth.year,
      firstDayOfTargetMonth.month + 1,
      0,
    ).day;
    final targetDay = date.day <= lastDayOfTargetMonth
        ? date.day
        : lastDayOfTargetMonth;

    return DateTime(
      firstDayOfTargetMonth.year,
      firstDayOfTargetMonth.month,
      targetDay,
    );
  }

  void _selectDay(int selectedIndex) {
    setState(() {
      widget.controller._updateSelectedDay(_availableDays[selectedIndex]);
    });
    _notifySelectedDateTimeChanged();
  }

  void _selectHour(int selectedHour) {
    setState(() {
      widget.controller._updateSelectedHour(selectedHour);
    });
    _notifySelectedDateTimeChanged();
  }

  void _selectMinute(int selectedMinute) {
    setState(() {
      widget.controller._updateSelectedMinute(selectedMinute);
    });
    _notifySelectedDateTimeChanged();
  }

  void _notifySelectedDateTimeChanged() {
    widget.onSelectedDateTimeChanged?.call(widget.controller.selectedDateTime);
  }

  String _formatDayForWheel(DateTime day) {
    final yesterday = _today.subtract(const Duration(days: 1));
    final tomorrow = _today.add(const Duration(days: 1));
    final abbreviatedMonth = _abbreviatedMonthNames[day.month - 1];

    if (_isSameDay(day, _today)) {
      return 'Hoy, ${day.day} $abbreviatedMonth';
    }

    if (_isSameDay(day, yesterday)) {
      return 'Ayer, ${day.day} $abbreviatedMonth';
    }

    if (_isSameDay(day, tomorrow)) {
      return 'Mañana, ${day.day} $abbreviatedMonth';
    }

    final abbreviatedWeekday = _abbreviatedWeekdayNames[day.weekday - 1];
    return '$abbreviatedWeekday, ${day.day} $abbreviatedMonth';
  }

  bool _isSameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int index) formatItem,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      diameterRatio: 1.35,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      overAndUnderCenterOpacity: 0.45,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Center(
            child: Text(
              formatItem(index),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    _hourScrollController.dispose();
    _minuteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: _wheelHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: _itemExtent, color: const Color(0xFFE5E7EB)),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildWheel(
                      controller: _dayScrollController,
                      itemCount: _availableDays.length,
                      formatItem: (index) =>
                          _formatDayForWheel(_availableDays[index]),
                      onSelectedItemChanged: _selectDay,
                    ),
                  ),
                  Expanded(
                    child: _buildWheel(
                      controller: _hourScrollController,
                      itemCount: 24,
                      formatItem: (index) => index.toString().padLeft(2, '0'),
                      onSelectedItemChanged: _selectHour,
                    ),
                  ),
                  Expanded(
                    child: _buildWheel(
                      controller: _minuteScrollController,
                      itemCount: 60,
                      formatItem: (index) => index.toString().padLeft(2, '0'),
                      onSelectedItemChanged: _selectMinute,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.controller.formattedSelectedDateTime),
      ],
    );
  }
}
