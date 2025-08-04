import 'package:flutter/material.dart';

class CustomBell extends StatefulWidget{
  final bool isActive;

  const CustomBell({Key? key, this.isActive = false}) : super(key: key);

  @override
  State<CustomBell> createState() => _CustomBellState();
}

class _CustomBellState extends State<CustomBell> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: widget.isActive
          ? const AssetImage('assets/icons/settings/system/bell-2.png')
          : const AssetImage('assets/icons/settings/system/bell.png'),
      width: 45,
      height: 45,
    );
  }
}