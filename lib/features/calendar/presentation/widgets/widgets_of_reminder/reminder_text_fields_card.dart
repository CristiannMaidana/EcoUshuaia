import 'package:flutter/material.dart';

class ReminderTextFieldsCard extends StatelessWidget {
  const ReminderTextFieldsCard({
    super.key,
    required this.titleField,
    required this.descriptionField,
  });

  final Widget titleField;
  final Widget descriptionField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE7EDF1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [titleField, const SizedBox(height: 20), descriptionField],
      ),
    );
  }
}
