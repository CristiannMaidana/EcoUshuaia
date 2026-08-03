import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
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
  final WheelPickerOfTimeController _wheelPickerOfTimeController =
      WheelPickerOfTimeController();

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
                    title: 'Fecha y hora',
                    initiallyOpen: false,
                    child: WheelPickerOfTime(
                      controller: _wheelPickerOfTimeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
