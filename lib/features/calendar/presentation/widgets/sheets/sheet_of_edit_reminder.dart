import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_icon_show_text.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/drop_bar.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/open_sheet_tile_custom.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/title_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/wheel_picker_of_time.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';

class SheetOfEditReminder extends SheetGeneric {
  const SheetOfEditReminder({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
  });

  @override
  State<SheetOfEditReminder> createState() => SheetOfEditReminderState();
}

class SheetOfEditReminderState extends SheetGenericState<SheetOfEditReminder> {
  final WheelPickerOfTimeController _wheelPickerOfTimeController = WheelPickerOfTimeController();
  final GlobalKey<DropBarState> _reminderNotificationDropBarKey = GlobalKey<DropBarState>();
  static const List<String> _reminderNotificationOptions = [
    'En el momento',
    '5 minutos antes',
    '10 minutos antes',
    '15 minutos antes',
    '30 minutos antes',
    '1 hora antes',
    '2 horas antes',
  ];
  bool _isReminderNotificationDropBarOpen = false;
  bool _isReminderButtonSelected = false;
  bool _isReminderButtonSelected1 = false;
  bool _isReminderButtonSelected2 = false;
  bool _isReminderButtonSelected3 = false;

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          BarraAgarre(),
          const SizedBox(height: 8),

          // Header row with title and close button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Editar recordatorio',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text('Personalizá los detalles de tu recordatorio.', 
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                  ],
                ),
              ),
              CircleIcon(icon: Icons.close, onPressed: collapseSheet),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // TODO: chango to allow only one selected button at a time, for default open the first button selected
              Row(
                children: [
                  ButtonIconShowText(
                    icon: Icons.insert_drive_file_outlined,
                    text: 'Elegir fecha',
                    isSelected: _isReminderButtonSelected,
                    onSelected: () async {
                      setState(() {
                        _isReminderButtonSelected = !_isReminderButtonSelected;
                      });
                    },
                    selectedColor: camarone600,
                  ),
                  const SizedBox(width: 10),

                  ButtonIconShowText(
                    icon: Icons.local_shipping,
                    text: 'Recolección',
                    isSelected: _isReminderButtonSelected1,
                    onSelected: () async {
                      setState(() {
                        _isReminderButtonSelected1 = !_isReminderButtonSelected1;
                      });
                    },
                    selectedColor: Color.fromRGBO(121, 83, 255, 1),
                  ),
                  const SizedBox(width: 10),
               
                  ButtonIconShowText(
                    icon: Icons.delete,
                    text: 'Llenado',
                    isSelected: _isReminderButtonSelected2,
                    onSelected: () async {
                      setState(() {
                        _isReminderButtonSelected2 = !_isReminderButtonSelected2;
                      });
                    },
                    selectedColor: Color.fromRGBO(255, 189, 74, 1),
                  ),
                  const SizedBox(width: 10),

                  ButtonIconShowText(
                    icon: Icons.recycling,
                    text: 'Disponible',
                    isSelected: _isReminderButtonSelected3,
                    onSelected: () async {
                      setState(() {
                        _isReminderButtonSelected3 = !_isReminderButtonSelected3;
                      });
                    },
                    selectedColor: Color.fromRGBO(88, 172, 255, 1),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 16),

              TitleOfReminder(
                controller: TitleOfReminderController(),
                onTitleChanged: (title) {
                  // Handle title change
                },
              ),
              const SizedBox(height: 16),
              
              DescriptionOfReminder(
                controller: DescriptionOfReminderController(),
                onDescriptionChanged: (description) {
                  // Handle description change
                },
              ),
              const SizedBox(height: 16),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha y hora', 
                    style: Theme.of(context).textTheme.labelLarge
                  ),
                  
                  // TODO: in title have to be a var with the date selected, for default is today
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
              
              Builder(
                builder: (reminderNotificationTileContext) {
                  return OpenSheetTileCustom(
                    title: Text('Avisarme', style: Theme.of(context).textTheme.labelLarge),
                    isOpen: _isReminderNotificationDropBarOpen,
                    onTap: () {
                      _reminderNotificationDropBarKey.currentState?.openDropBar(
                        reminderNotificationTileContext,
                      );
                    },
                  );
                },
              ),
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
          ),
        ),
      )
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
