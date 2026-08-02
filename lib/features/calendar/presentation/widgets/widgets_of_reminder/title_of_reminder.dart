import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';

class TitleOfReminderController extends TextEditingController {
  String get reminderTitle => text.trim();
}

class TitleOfReminder extends StatelessWidget {
  const TitleOfReminder({
    super.key,
    required this.controller,
    this.onTitleChanged,
  });

  final TitleOfReminderController controller;
  final ValueChanged<String>? onTitleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Título del recordatorio', 
          style: Theme.of(context).textTheme.labelLarge
        ),
        const SizedBox(height: 8),
        
        TextFormFieldCustom(
          controller: controller,
          onChanged: onTitleChanged,
          labelText: 'ingresa un titulo...',
          prefixIcon: const Icon(Icons.insert_drive_file_outlined),
        ),
      ],
    );
  }
}
