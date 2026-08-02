import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';

class DescriptionOfReminderController extends TextEditingController {
  static const int maximumCharacterCount = 200;

  String get reminderDescription => text.trim();

  int get characterCount => text.characters.length;

  bool get exceedsCharacterLimit => characterCount > maximumCharacterCount;
}

class DescriptionOfReminder extends StatefulWidget {
  const DescriptionOfReminder({
    super.key,
    required this.controller,
    this.onDescriptionChanged,
  });

  final DescriptionOfReminderController controller;
  final ValueChanged<String>? onDescriptionChanged;

  @override
  State<DescriptionOfReminder> createState() => _DescriptionOfReminderState();
}

class _DescriptionOfReminderState extends State<DescriptionOfReminder> {
  late String _previousDescription;

  @override
  void initState() {
    super.initState();
    _previousDescription = widget.controller.text;
    widget.controller.addListener(_handleDescriptionChanged);
  }

  @override
  void didUpdateWidget(covariant DescriptionOfReminder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleDescriptionChanged);
      _previousDescription = widget.controller.text;
      widget.controller.addListener(_handleDescriptionChanged);
    }
  }

  void _handleDescriptionChanged() {
    if (_previousDescription == widget.controller.text) return;

    _previousDescription = widget.controller.text;
    setState(() {});
    widget.onDescriptionChanged?.call(widget.controller.reminderDescription);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleDescriptionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = widget.controller.characterCount;
    final exceedsCharacterLimit = widget.controller.exceedsCharacterLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripcion (Opcional)', 
          style: Theme.of(context).textTheme.labelLarge
        ),
        const SizedBox(height: 8),

        TextFormFieldCustom(
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          labelText: 'ingresa una descripcion...',
        ),
        const SizedBox(height: 8),

        Text('$characterCount/${DescriptionOfReminderController.maximumCharacterCount} letras', style: Theme.of(context).textTheme.labelLarge),
        if (exceedsCharacterLimit)
          Text('La descripcion no puede superar las 200 letras.',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.red
            ),
          ),
      ],
    );
  }
}
