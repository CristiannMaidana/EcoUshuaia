import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget{
  final String contenido;
  final IconData icon;
  final Color colorIcon;

  const DataContainer({
    super.key, 
    required this.contenido,
    required this.icon,
    required this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[400]!, width: 1),
      ),
    );
  }
}