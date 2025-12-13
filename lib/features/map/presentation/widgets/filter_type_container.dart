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
      link: _link,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          children: [
            Icon(Icons.filter_list, color: Colors.black54),
            SizedBox(width: 5),
            Text('Filtros', style: Theme.of(context).textTheme.labelLarge),
          ],
        )
      ),
    );
  }
}