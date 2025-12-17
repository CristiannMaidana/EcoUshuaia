import 'package:eco_ushuaia/features/map/presentation/widgets/filter_container.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final List<String> categorias;
  final ValueChanged<String> onSelected;

  const FilterButton({
    super.key,
    required this.categorias,
    required this.onSelected,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton>{
  final LayerLink _link = LayerLink();

  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OutlinedButton(
        onPressed: () {FilterContainer(categorias: widget.categorias);},
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