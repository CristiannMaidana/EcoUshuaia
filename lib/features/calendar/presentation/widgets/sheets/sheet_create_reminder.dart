import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/button_icon_show_text.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/content_of_reminder_container.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/widgets_of_reminder/content_of_reminder_time_and_date.dart';
import 'package:flutter/material.dart';

enum _ReminderCategory { personal, container, collection }

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
  _ReminderCategory _selectedCategory = _ReminderCategory.personal;

  void _selectCategory(_ReminderCategory category) {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarraAgarre(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo recordatorio',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Elegí el tipo de recordatorio que querés crear.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF737985),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ButtonIconShowText(
                    icon: Icons.insert_drive_file_outlined,
                    text: 'Recordatorio personal',
                    isSelected: _selectedCategory == _ReminderCategory.personal,
                    onSelected: () async =>
                        _selectCategory(_ReminderCategory.personal),
                    selectedColor: verde500,
                  ),
                  const SizedBox(width: 12),
                  ButtonIconShowText(
                    icon: Icons.delete_outline,
                    text: 'Recordatorio de contenedor',
                    isSelected:
                        _selectedCategory == _ReminderCategory.container,
                    onSelected: () async =>
                        _selectCategory(_ReminderCategory.container),
                    selectedColor: verde500,
                  ),
                  const SizedBox(width: 12),
                  ButtonIconShowText(
                    icon: Icons.local_shipping_outlined,
                    text: 'Recordatorio de recolección',
                    isSelected:
                        _selectedCategory == _ReminderCategory.collection,
                    onSelected: () async =>
                        _selectCategory(_ReminderCategory.collection),
                    selectedColor: verde500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            switch (_selectedCategory) {
              _ReminderCategory.personal =>
                const ContentOfReminderTimeAndDate(),
              _ReminderCategory.container => const ContentOfReminderContainer(),
              _ReminderCategory.collection => const _CollectionReminderNotice(),
            },
          ],
        ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) {
    if (_selectedCategory == _ReminderCategory.collection) return null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: ElevatedButton(
        onPressed: collapseSheet,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text('Crear recordatorio'),
      ),
    );
  }
}

class _CollectionReminderNotice extends StatelessWidget {
  const _CollectionReminderNotice();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 56,
              color: camarone700,
            ),
            const SizedBox(height: 16),
            Text(
              'Recordatorio de recolección',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'La configuración de avisos de recolección estará disponible próximamente.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
