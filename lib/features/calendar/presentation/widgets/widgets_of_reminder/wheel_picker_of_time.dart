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
  late final int _currentHour;
  late final List<DateTime> _availableDays;
  late final FixedExtentScrollController _dayScrollController;
  late final FixedExtentScrollController _hourScrollController;
  late final FixedExtentScrollController _minuteScrollController;
  bool _isCorrectingHourSelection = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _currentHour = now.hour;
    _availableDays = _createAvailableDays();
    var selectedDateTime = widget.controller.selectedDateTime;
    final selectedDayIndex = _availableDays.indexWhere(
      (day) => _isSameDay(day, selectedDateTime),
    );

    if (selectedDayIndex < 0) {
      widget.controller._updateSelectedDay(_today);
      selectedDateTime = widget.controller.selectedDateTime;
    }

    if (_isSameDay(selectedDateTime, _today) &&
        selectedDateTime.hour < _currentHour) {
      widget.controller._updateSelectedHour(_currentHour);
      selectedDateTime = widget.controller.selectedDateTime;
    }

    final initialDayIndex = selectedDayIndex >= 0 ? selectedDayIndex : 0;

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
    return List<DateTime>.generate(
      91,
      (index) => _today.add(Duration(days: index)),
    );
  }

  void _selectDay(int selectedIndex) {
    final selectedDay = _availableDays[selectedIndex];
    final mustUseCurrentHour =
        _isSameDay(selectedDay, _today) &&
        widget.controller.selectedDateTime.hour < _currentHour;

    setState(() {
      widget.controller._updateSelectedDay(selectedDay);

      if (mustUseCurrentHour) {
        widget.controller._updateSelectedHour(_currentHour);
      }
    });

    if (mustUseCurrentHour) {
      _moveHourWheelTo(_currentHour);
    }

    _notifySelectedDateTimeChanged();
  }

  void _selectHour(int selectedHour) {
    if (_isCorrectingHourSelection) return;

    if (!_isHourSelectable(selectedHour)) {
      _moveHourWheelTo(widget.controller.selectedDateTime.hour);
      return;
    }

    setState(() {
      widget.controller._updateSelectedHour(selectedHour);
    });
    _notifySelectedDateTimeChanged();
  }

  bool _isHourSelectable(int hour) {
    final selectedDay = widget.controller.selectedDateTime;
    return !_isSameDay(selectedDay, _today) || hour >= _currentHour;
  }

  Future<void> _moveHourWheelTo(int hour) async {
    if (!_hourScrollController.hasClients) return;

    _isCorrectingHourSelection = true;
    await _hourScrollController.animateToItem(
      hour,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
    );
    _isCorrectingHourSelection = false;
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
    final tomorrow = _today.add(const Duration(days: 1));
    final abbreviatedMonth = _abbreviatedMonthNames[day.month - 1];

    if (_isSameDay(day, _today)) {
      return 'Hoy, ${day.day} $abbreviatedMonth';
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
    bool Function(int index)? isItemEnabled,
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
          final itemEnabled = isItemEnabled?.call(index) ?? true;

          return Center(
            child: Text(
              formatItem(index),
              style: itemEnabled ? null : const TextStyle(color: Colors.grey),
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
                      isItemEnabled: _isHourSelectable,
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
