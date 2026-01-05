import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final VoidCallback onSelected;
  final VoidCallback changes; // Para notificar el cambio de estado de contenido

  const FilterButton({
    super.key,
    required this.onSelected,
    required this.changes,
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
        onPressed: () {
          widget.onSelected(); 
          widget.changes(); 
        },
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