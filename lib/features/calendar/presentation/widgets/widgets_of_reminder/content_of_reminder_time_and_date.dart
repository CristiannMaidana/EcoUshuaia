import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar_option_dropdown.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_selected.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/reminder_text_fields_card.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/title_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/wheel_picker_of_time.dart';
import 'package:flutter/material.dart';

class ContentOfReminderTimeAndDateValues {
  final String reminderTitle;
  final String reminderDescription;
  final DateTime selectedDateTime;
  final String? selectedRepeatOption;
  final String? selectedNotificationOption;

  const ContentOfReminderTimeAndDateValues({
    required this.reminderTitle,
    required this.reminderDescription,
    required this.selectedDateTime,
    required this.selectedRepeatOption,
    required this.selectedNotificationOption,
  });
}

class ContentOfReminderTimeAndDate extends StatefulWidget {
  const ContentOfReminderTimeAndDate({super.key});

  @override
  ContentOfReminderTimeAndDateState createState() =>
      ContentOfReminderTimeAndDateState();
}

class ContentOfReminderTimeAndDateState
    extends State<ContentOfReminderTimeAndDate> {
  static const List<String> _reminderRepeatOptions = [
    'No repetir',
    'Todos los días',
    'Cada semana',
    'Cada mes',
  ];
  static const List<String> _reminderNotificationOptions = [
    'En el momento',
    '5 minutos antes',
    '10 minutos antes',
    '15 minutos antes',
    '30 minutos antes',
    '1 hora antes',
    '2 horas antes',
  ];

  final TitleOfReminderController _titleOfReminderController =
      TitleOfReminderController();
  final DescriptionOfReminderController _descriptionOfReminderController =
      DescriptionOfReminderController();
  final WheelPickerOfTimeController _wheelPickerOfTimeController =
      WheelPickerOfTimeController();
  String? _selectedRepeatOption;
  String? _selectedNotificationOption;

  ContentOfReminderTimeAndDateValues get reminderValues {
    return ContentOfReminderTimeAndDateValues(
      reminderTitle: _titleOfReminderController.reminderTitle,
      reminderDescription: _descriptionOfReminderController.reminderDescription,
      selectedDateTime: _wheelPickerOfTimeController.selectedDateTime,
      selectedRepeatOption: _selectedRepeatOption,
      selectedNotificationOption: _selectedNotificationOption,
    );
  }

  @override
  void dispose() {
    _titleOfReminderController.dispose();
    _descriptionOfReminderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReminderTextFieldsCard(
          titleField: TitleOfReminder(controller: _titleOfReminderController),
          descriptionField: DescriptionOfReminder(
            controller: _descriptionOfReminderController,
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Fecha',
          subtitle: _wheelPickerOfTimeController.formattedSelectedDate,
          icon: Icons.calendar_today_outlined,
          position: CalendarOptionDropdownPosition.top,
          expandedChild: Padding(
            padding: const EdgeInsets.all(16),
            child: WheelPickerOfTime(
              controller: _wheelPickerOfTimeController,
              mode: WheelPickerOfTimeMode.date,
              onSelectedDateTimeChanged: (_) => setState(() {}),
            ),
          ),
        ),
        CalendarOptionDropdown(
          title: 'Hora',
          subtitle: _wheelPickerOfTimeController.formattedSelectedTime,
          icon: Icons.access_time_outlined,
          position: CalendarOptionDropdownPosition.bottom,
          expandedChild: Padding(
            padding: const EdgeInsets.all(16),
            child: WheelPickerOfTime(
              controller: _wheelPickerOfTimeController,
              mode: WheelPickerOfTimeMode.time,
              onSelectedDateTimeChanged: (_) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Repetir',
          subtitle: _selectedRepeatOption ?? 'Seleccioná una frecuencia',
          icon: Icons.repeat,
          expandedChild: _buildSelectableOptions(
            options: _reminderRepeatOptions,
            selectedOption: _selectedRepeatOption,
            onOptionSelected: (option) {
              setState(() => _selectedRepeatOption = option);
            },
          ),
        ),
        const SizedBox(height: 16),

        CalendarOptionDropdown(
          title: 'Notificación',
          subtitle: _selectedNotificationOption ?? 'Seleccioná cuándo avisarte',
          icon: Icons.notifications_outlined,
          expandedChild: _buildSelectableOptions(
            options: _reminderNotificationOptions,
            selectedOption: _selectedNotificationOption,
            onOptionSelected: (option) {
              setState(() => _selectedNotificationOption = option);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableOptions({
    required List<String> options,
    required String? selectedOption,
    required ValueChanged<String> onOptionSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((option) {
        return ButtonSelected(
          text: option,
          isSelected: option == selectedOption,
          onPressed: () => onOptionSelected(option),
        );
      }).toList(),
    );
  }
}
