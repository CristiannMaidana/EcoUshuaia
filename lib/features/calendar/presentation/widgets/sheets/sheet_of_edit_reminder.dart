import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/description_of_reminder.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/title_of_reminder.dart';
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
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TitleOfReminder(
                controller: TitleOfReminderController(),
                onTitleChanged: (title) {
                  // Handle title change
                },
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DescriptionOfReminder(
                controller: DescriptionOfReminderController(),
                onDescriptionChanged: (description) {
                  // Handle description change
                },
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      )
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}