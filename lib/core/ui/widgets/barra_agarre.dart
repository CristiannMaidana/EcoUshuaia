import 'package:flutter/material.dart';
class BarraAgarre extends StatelessWidget {
  const BarraAgarre({super.key});

  @override
  Widget build(BuildContext context) =>
  Center(
    child: Container(
      width: 44,
      height: 5,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(999),
      ),
    ),
  );
}