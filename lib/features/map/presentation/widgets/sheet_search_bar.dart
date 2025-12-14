import 'package:flutter/material.dart';

class SheetSearchBar extends StatefulWidget{
  final Widget nav_bar;

  SheetSearchBar({
    Key? key,
    required this.nav_bar,
  }) :super(key: key);

  @override
  State<SheetSearchBar> createState() => _SheetSearchBarState();
}

class _SheetSearchBarState extends State<SheetSearchBar>{
  late DraggableScrollableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }


  @override
  Widget build (BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: .095,
        minChildSize: .095,
        maxChildSize: .8,
        builder: (context, scrollController) {
          return Container(
            height: 60,
            width: 400,
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(width: 1, color: Colors.black54),
            ),
          );
        }
      ),
    );  
  }
}