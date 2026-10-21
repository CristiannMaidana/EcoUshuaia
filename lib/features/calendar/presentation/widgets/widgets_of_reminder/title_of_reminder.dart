import 'package:eco_ushuaia/core/theme/colors.dart';
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
        TextFormField(
          controller: controller,
          onChanged: onTitleChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Titulo...',
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E6EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: camarone600),
            ),
          ),
        ),
      ],
    );
  }
}
