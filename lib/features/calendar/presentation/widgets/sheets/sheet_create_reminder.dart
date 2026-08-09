import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_icon_show_text.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/content_of_reminder_container.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/content_of_reminder_time_and_date.dart';
import 'package:flutter/material.dart';

class SheetCreateReminder extends SheetGeneric {
  const SheetCreateReminder({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.99,
  });

  @override
  State<SheetCreateReminder> createState() => SheetCreateReminderState();
}

class SheetCreateReminderState extends SheetGenericState<SheetCreateReminder> {
  final GlobalKey<ContentOfReminderTimeAndDateState> _contentOfReminderTimeAndDateKey = GlobalKey<ContentOfReminderTimeAndDateState>();
  final GlobalKey<ContentOfReminderContainerState> _contentOfReminderContainerKey = GlobalKey<ContentOfReminderContainerState>();
  bool _isReminderButtonSelectedUser = true;
  bool _isReminderButtonSelectedContainer = false;

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
              Row(
                children: [
                  ButtonIconShowText(
                    icon: Icons.insert_drive_file_outlined,
                    text: 'Recordatorio personal',
                    isSelected: _isReminderButtonSelectedUser,
                    onSelected: () async {
                      if (_isReminderButtonSelectedUser) return;

                      setState(() {
                        _isReminderButtonSelectedUser = true;
                        _isReminderButtonSelectedContainer = false;
                      });
                    },
                    selectedColor: camarone600,
                  ),
                  const SizedBox(width: 15),

                  ButtonIconShowText(
                    icon: Icons.delete,
                    text: 'Recordatorio de reciclaje',
                    isSelected: _isReminderButtonSelectedContainer,
                    onSelected: () async {
                      if (_isReminderButtonSelectedContainer) return;

                      setState(() {
                        _isReminderButtonSelectedUser = false;
                        _isReminderButtonSelectedContainer = true;
                      });
                    },
                    selectedColor: Color.fromRGBO(255, 189, 74, 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isReminderButtonSelectedUser)
                ContentOfReminderTimeAndDate(
                  key: _contentOfReminderTimeAndDateKey,
                )
              else
                ContentOfReminderContainer(
                  key: _contentOfReminderContainerKey,
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
        ),
        child: Text('Crear recordatorio', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}
