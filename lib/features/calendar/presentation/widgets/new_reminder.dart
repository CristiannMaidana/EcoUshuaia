import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/custom_time_picker.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/date_time_section.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/repeat_reminder.dart';
import 'package:flutter/material.dart';

class NewReminder extends StatefulWidget {
  const NewReminder({super.key});

  @override
  State<NewReminder> createState() => _StateNewReminder();
}

class _StateNewReminder extends State<NewReminder> {
  final _scrollCtrlTitulo = ScrollController();
  final _scrollCtrlNotas = ScrollController();

  bool _dateOpen = false;
  bool _hourEnabled = false;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _scrollCtrlTitulo.dispose();
    _scrollCtrlNotas.dispose();
    super.dispose();
  }

  String _formatTime(BuildContext context, TimeOfDay? t) {
    if (t == null) return '—';
    final use24h = MediaQuery.of(context).alwaysUse24HourFormat;
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(t, alwaysUse24HourFormat: use24h);
  }

  Future<void> _onHourSwitchChanged(bool v) async {
    if (!v) {
      setState(() {
        _hourEnabled = false;
      });
      return;
    }

    final picked = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomTimePicker(
        initial: _selectedTime ?? TimeOfDay.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _hourEnabled = true;
        _selectedTime = picked;
      });
    } else {
      setState(() => _hourEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context){
    final horaTexto = _formatTime(context, _selectedTime);

    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            //header
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIcon(icon: Icons.close, onPressed: () {}),
                Text("Nuevo recordatorio", style: Theme.of(context).textTheme.bodyLarge),
                CircleIcon(icon: Icons.check_sharp, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            // Título y Notas
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  _label(context, _scrollCtrlTitulo, "Título"),
                  _label(context, _scrollCtrlNotas, "Notas"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Fecha y hora
            DateTimeSection(
              dateOpen: _dateOpen,
              onToggleFecha: () => setState(() => _dateOpen = !_dateOpen),
              hourEnabled: _hourEnabled,
              onHourChanged: _onHourSwitchChanged,
              hourText: horaTexto,
            ),
            const SizedBox(height: 20),
            //Repetir
            RepeatReminder()
          ],
        ),
      ),
    );
  }
}

Widget _label(BuildContext context, ScrollController ctrl, String label) {
  return Scrollbar(
    controller: ctrl,
    thumbVisibility: true,
    child: TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 4,
      scrollController: ctrl,
      style: Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: Colors.transparent,
      ),
    ),
  );
}