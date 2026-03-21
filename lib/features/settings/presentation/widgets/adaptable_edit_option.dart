import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/buttons/standard_button.dart';
import 'package:eco_ushuaia/features/auth/presentation/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';

class AdaptableEditField {
  final String keyName;
  final String label;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final StringValidator? validator;

  const AdaptableEditField({
    required this.keyName,
    required this.label,
    required this.hintText,
    this.initialValue = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });
}

class AdaptableEditOption extends StatefulWidget {
  final String screenTitle;
  final String infoText;
  final List<AdaptableEditField> fields;
  final Future<void> Function(Map<String, String> values)? onSave;

  const AdaptableEditOption({
    super.key,
    required this.screenTitle,
    required this.infoText,
    required this.fields,
    this.onSave,
  });

  @override
  State<AdaptableEditOption> createState() => _AdaptableEditOptionState();
}

class _AdaptableEditOptionState extends State<AdaptableEditOption> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controllers = widget.fields
        .map((field) => TextEditingController(text: field.initialValue))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    final values = <String, String>{};
    for (var i = 0; i < widget.fields.length; i++) {
      values[widget.fields[i].keyName] = _controllers[i].text.trim();
    }

    if (widget.onSave == null) {
      Navigator.pop(context, values);
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await widget.onSave!(values);
      if (!mounted) return;
      Navigator.pop(context, values);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.screenTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.infoText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic fields
                ...List.generate(widget.fields.length, (index) {
                  final field = widget.fields[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == widget.fields.length - 1 ? 0 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(field.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700
                            ),
                        ),
                        const SizedBox(height: 6),
                        TextFormFieldCustom(
                          controller: _controllers[index],
                          labelText: field.hintText,
                          keyboardType: field.keyboardType,
                          obscureText: field.obscureText,
                          validate: field.validator,
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 28),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Cancelar',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StandardButton(
                        texto: _saving ? 'Guardando...' : 'Guardar',
                        height: 48,
                        onPressed: _handleSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
