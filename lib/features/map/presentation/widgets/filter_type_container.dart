import 'package:flutter/material.dart';

class FilterTypeContainer extends StatelessWidget {
  final List<String> categorias;
  final ValueChanged<String> onSelected;

  const FilterTypeContainer({
    super.key,
    required this.categorias,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack();
  }
}