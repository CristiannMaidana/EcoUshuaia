import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/drop_bar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/open_sheet_tile_custom.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/title_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/wheel_picker_of_time.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
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
  ContentOfReminderTimeAndDateState createState() => ContentOfReminderTimeAndDateState();
}

class ContentOfReminderTimeAndDateState extends State<ContentOfReminderTimeAndDate> {
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

  final TitleOfReminderController _titleOfReminderController = TitleOfReminderController();
  final DescriptionOfReminderController _descriptionOfReminderController = DescriptionOfReminderController();
  final WheelPickerOfTimeController _wheelPickerOfTimeController = WheelPickerOfTimeController();
  final GlobalKey<DropBarState> _reminderRepeatDropBarKey = GlobalKey<DropBarState>();
  final GlobalKey<DropBarState> _reminderNotificationDropBarKey = GlobalKey<DropBarState>();

  bool _isReminderRepeatDropBarOpen = false;
  bool _isReminderNotificationDropBarOpen = false;

  ContentOfReminderTimeAndDateValues get reminderValues {
    return ContentOfReminderTimeAndDateValues(
      reminderTitle: _titleOfReminderController.reminderTitle,
      reminderDescription: _descriptionOfReminderController.reminderDescription,
      selectedDateTime: _wheelPickerOfTimeController.selectedDateTime,
      selectedRepeatOption:  _reminderRepeatDropBarKey.currentState?.selectedValue,
      selectedNotificationOption: _reminderNotificationDropBarKey.currentState?.selectedValue,
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
        TitleOfReminder(controller: _titleOfReminderController),
        const SizedBox(height: 16),

        DescriptionOfReminder(controller: _descriptionOfReminderController),
        const SizedBox(height: 16),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha y hora', style: Theme.of(context).textTheme.labelLarge),
            ExpansionTileCustom(
              title: 'Selecciona fecha y hora',
              initiallyOpen: false,
              child: WheelPickerOfTime(
                controller: _wheelPickerOfTimeController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildRepeatSelector(context),
        DropBar(
          key: _reminderRepeatDropBarKey,
          options: _reminderRepeatOptions,
          onOpenChanged: (isOpen) {
            setState(() {
              _isReminderRepeatDropBarOpen = isOpen;
            });
          },
        ),
        const SizedBox(height: 16),
        
        _buildNotificationSelector(context),
        DropBar(
          key: _reminderNotificationDropBarKey,
          options: _reminderNotificationOptions,
          onOpenChanged: (isOpen) {
            setState(() {
              _isReminderNotificationDropBarOpen = isOpen;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRepeatSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repetir', style: Theme.of(context).textTheme.labelLarge),
        Builder(
          builder: (reminderRepeatTileContext) {
            return OpenSheetTileCustom(
              title: Row(
                children: [
                  const Icon(Icons.repeat, color: camarone600),
                  const SizedBox(width: 10),
                  Text(
                    'Repetir',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              isOpen: _isReminderRepeatDropBarOpen,
              onTap: () {
                _reminderRepeatDropBarKey.currentState?.openDropBar(
                  reminderRepeatTileContext,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notificación', style: Theme.of(context).textTheme.labelLarge),
        Builder(
          builder: (reminderNotificationTileContext) {
            return OpenSheetTileCustom(
              title: Row(
                children: [
                  const Icon(Icons.notifications, color: camarone600),
                  const SizedBox(width: 10),
                  Text(
                    'Avisarme',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              isOpen: _isReminderNotificationDropBarOpen,
              onTap: () {
                _reminderNotificationDropBarKey.currentState?.openDropBar(
                  reminderNotificationTileContext,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
