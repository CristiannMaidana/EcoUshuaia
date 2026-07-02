import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SwitchToggle extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final bool? value;

  const SwitchToggle({super.key, this.onChanged, this.value});

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle> {
  bool habilitado = false;

  @override
  Widget build(BuildContext context) {
    final currentValue = widget.value ?? habilitado;

    return Switch(
      value: currentValue,
      activeThumbColor: camarone600,
      activeTrackColor: camarone200,
      inactiveThumbColor: camarone600,
      inactiveTrackColor: Colors.white,
      trackOutlineColor: const WidgetStatePropertyAll(camarone700),
      trackOutlineWidth: const WidgetStatePropertyAll(1.3),
      onChanged: (bool value) {
        if (widget.value == null) {
          setState(() {
            habilitado = value;
          });
        }
        widget.onChanged?.call(value);
      },
    );
  }
}
