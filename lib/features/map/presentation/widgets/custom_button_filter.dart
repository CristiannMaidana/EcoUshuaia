import 'package:flutter/material.dart';

class CustomButtonFilter extends StatefulWidget{
  final String label;
  final VoidCallback onTap;

  const CustomButtonFilter({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<CustomButtonFilter> createState() => _CustomButtonFilterState();
}

class _CustomButtonFilterState extends State<CustomButtonFilter> {
  late bool _selected = false;

  void _setSelected() {
    setState(() {
      _selected = !_selected;
    });
  }

  void resetBottom() {
    setState(() {
      _selected = false;
    });
  }

  @override
  Widget build (BuildContext context){
    final bgColor = _selected ? const Color.fromARGB(255, 214, 255, 219) : Colors.white;
    final bgborde = _selected ? const Color.fromARGB(255, 56, 67, 57) : Colors.grey;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.black,
        side: BorderSide(width: 1, color: bgborde),
      ),
      onPressed: _setSelected, 
      child: Text(widget.label, style: TextStyle(fontSize: 13),)
    );
  }
}