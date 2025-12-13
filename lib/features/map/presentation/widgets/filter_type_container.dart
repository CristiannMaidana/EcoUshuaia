import 'package:flutter/material.dart';

class FilterTypeContainer extends StatefulWidget {
  final List<String> categorias;
  final ValueChanged<String> onSelected;

  const FilterTypeContainer({
    super.key,
    required this.categorias,
    required this.onSelected,
  });

  @override
  State<FilterTypeContainer> createState() => _FilterPopoverAnchorState();
}

class _FilterPopoverAnchorState extends State<FilterTypeContainer>{
  
  Widget build(BuildContext context) {
    return Stack();
  }
}