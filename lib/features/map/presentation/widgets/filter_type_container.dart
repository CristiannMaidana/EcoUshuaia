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
  final LayerLink _link = LayerLink();

  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link
    );
  }
}