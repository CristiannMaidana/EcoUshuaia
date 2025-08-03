import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool habilitado = true;

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
      },
    );
  }
}