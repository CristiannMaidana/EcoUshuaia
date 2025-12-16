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

    return OutlinedButton(
      onPressed: () {}, 
      child: Text(widget.label)
    );
  }
}