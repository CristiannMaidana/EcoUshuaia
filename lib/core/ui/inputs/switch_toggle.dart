import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SwitchToggle extends StatefulWidget {
  final ValueChanged<bool> ? onChanged;
  
  const SwitchToggle({
    super.key, 
    this.onChanged
  });

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle> {
  bool habilitado = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: habilitado,
      activeColor: camarone600,
      activeTrackColor: camarone300,
      inactiveThumbColor: camarone600,
      inactiveTrackColor: Colors.white,
      onChanged: (bool value) {
        setState(() {
          habilitado = value;
        });
        widget.onChanged?.call(value);
      },
    );
  }
}