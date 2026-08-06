import 'package:eco_ushuaia/core/theme/colors.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción (opcional)',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 110,
          child: Stack(
            children: [
              TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                expands: true,
                maxLength: DescriptionOfReminderController.maximumCharacterCount,
                buildCounter:( context, {
                      required currentLength,
                      required isFocused,
                      required maxLength,
                    }) => null,
                textAlignVertical: TextAlignVertical.top,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Agregá más información...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600]
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
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
              Positioned(
                right: 16,
                bottom: 14,
                child: IgnorePointer(
                  child: Text('$characterCount/${DescriptionOfReminderController.maximumCharacterCount}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
