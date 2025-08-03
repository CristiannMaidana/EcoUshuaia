import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final ValueChanged<bool> ? onChanged;
  const CustomSwitch({
    super.key, 
    this.onChanged
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
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