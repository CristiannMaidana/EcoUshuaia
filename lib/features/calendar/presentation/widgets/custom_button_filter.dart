import 'package:flutter/material.dart';

class CustomButtonFilter extends StatefulWidget{
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomButtonFilter({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<CustomButtonFilter> createState() => _CustomButtonFilterState();
}

class _CustomButtonFilterState extends State<CustomButtonFilter> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void _setSelected() {
    setState(() {
      _selected = !_selected;
    });
  }

  @override
  Widget build (BuildContext context){
    final bgColor = _selected ? Colors.white : const Color.fromARGB(255, 214, 255, 219);
    final bgborde = _selected ? Colors.grey : const Color.fromARGB(255, 56, 67, 57);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.black,
        side: BorderSide(width: 1, color: bgborde),
      ),
      onPressed: _setSelected, 
      child: Text(widget.label)
    );
  }
}