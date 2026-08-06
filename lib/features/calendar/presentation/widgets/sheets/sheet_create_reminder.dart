import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_icon_show_text.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/content_of_reminder_time_and_date.dart';
import 'package:flutter/material.dart';

class SheetCreateReminder extends SheetGeneric {
  const SheetCreateReminder({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.95,
  });

  @override
  State<SheetCreateReminder> createState() => SheetCreateReminderState();
}

class SheetCreateReminderState extends SheetGenericState<SheetCreateReminder> {
  final GlobalKey<ContentOfReminderTimeAndDateState>
      _contentOfReminderTimeAndDateKey =
      GlobalKey<ContentOfReminderTimeAndDateState>();
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
                    Text('Crear recordatorio',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text('Agregarás un nuevo recordatorio a tu calendario.', 
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

              ContentOfReminderTimeAndDate(
                key: _contentOfReminderTimeAndDateKey,
              ),
              
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget footerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          //TODO: create the post for the reminder
          collapseSheet();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 48),
          backgroundColor: camarone600,
        ),
        child: Text('Crear recordatorio', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}
