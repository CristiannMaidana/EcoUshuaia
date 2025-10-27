import 'package:eco_ushuaia/features/calendar/presentation/widgets/am_pm_selector.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/whell_box.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initial;
  const CustomTimePicker({required this.initial});

  @override
  State<CustomTimePicker> createState() => CustomTimePickerState();
}

class CustomTimePickerState extends State<CustomTimePicker> {
  late int _hour12;
  late int _minute;
  late bool _isAm;

  late FixedExtentScrollController _hCtrl;
  late FixedExtentScrollController _mCtrl;

  @override
  void initState() {
    super.initState();
    final h = widget.initial.hour;
    _isAm = h < 12;
    _hour12 = (h % 12 == 0) ? 12 : (h % 12);
    _minute = widget.initial.minute;

    _hCtrl = FixedExtentScrollController(initialItem: _hour12 - 1);
    _mCtrl = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hCtrl.dispose();
    _mCtrl.dispose();
    super.dispose();
  }

  int _toHour24() {
    int h = _hour12 % 12;
    if (!_isAm) h += 12;
    return h;
  }

  @override
  Widget build(BuildContext context) {
    const itemExtent = 40.0;
    const wheelHeight = itemExtent * 2.5;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
            child: Row(
              children: [
                Text('Elegir hora', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          const Divider(height: 1),

          // Cuerpo
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                // Caja Hora
                WheelBox(
                  label: 'Hora',
                  width: 120,
                  height: wheelHeight,
                  controller: _hCtrl,
                  itemCount: 12,
                  itemExtent: itemExtent,
                  display: (i) => '${(i + 1)}',
                  onSelected: (i) => setState(() => _hour12 = i + 1),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(':', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600)),
                ),

                // Caja Minuto
                WheelBox(
                  label: 'Minuto',
                  width: 120,
                  height: wheelHeight,
                  controller: _mCtrl,
                  itemCount: 60,
                  itemExtent: itemExtent,
                  display: (i) => i.toString().padLeft(2, '0'),
                  onSelected: (i) => setState(() => _minute = i),
                ),

                const SizedBox(width: 10),

                // AM/PM
                AmPmSelector(
                  isAm: _isAm,
                  onChanged: (v) => setState(() => _isAm = v),
                  height: wheelHeight,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // Botones
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop<TimeOfDay>(null),
                  child: Text('Cancelar', style: Theme.of(context).textTheme.labelMedium,),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    final t = TimeOfDay(hour: _toHour24(), minute: _minute);
                    Navigator.of(context).pop<TimeOfDay>(t);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                    minimumSize: MaterialStatePropertyAll<Size>(const Size(80, 45)),
                  ),
                  child: Text('OK', style: Theme.of(context).textTheme.labelMedium,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
