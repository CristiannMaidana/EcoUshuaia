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
  static const double _min = .096;
  static const double _max = .80;
  static const List<double> _snapPoints = [_min, .30, .55, _max]; 
  static const double _borde = 30;
  static const double _bottom = 20;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  // Manejo de altura desde incio
  void _dragFromHeader(DragUpdateDetails d) {
    final h = MediaQuery.of(context).size.height;
    final next = (_controller.size - d.delta.dy / h).clamp(_min, _max);
    _controller.jumpTo(next);
  }

    // Manejo de altura para arrastre
  void _endDragFromHeader(DragEndDetails d) {
    final v = d.primaryVelocity ?? 0.0;
    const double vThresh = 900;
    late double target;

    if (v > vThresh) {
      target = _min;                          // tirón hacia abajo -> colapsar
    } else if (v < -vThresh) {
      target = _max;                          // tirón hacia arriba -> expandir
    } else {
      // sin flick fuerte: snap al punto más cercano
      final cur = _controller.size;
      target = _snapPoints.reduce((a, b) =>
        (cur - a).abs() < (cur - b).abs() ? a : b);
    }

    final dist = (target - _controller.size).abs();
    final ms = (180 + 220 * dist).toInt();    // duración según distancia (≈180–400ms)

    _controller.animateTo(
      target,
      duration: Duration(milliseconds: ms),
      curve: Curves.easeOutCubic,
    );
  }
    
  @override
  Widget build (BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, _bottom),
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: _min,
        minChildSize: _min,
        maxChildSize: _max,
        builder: (context, scrollController) {
          return Container(
            width: 400,
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(_borde)),
              border: Border.all(width: 1, color: Colors.black54),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra
                Center(
                  child: Container(
                    width: 50, height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Gestor de movimiento
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _dragFromHeader,
                  onVerticalDragEnd: _endDragFromHeader,
                  child: widget.nav_bar,
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                  )
                )
              ]
            )
          );
        }
      ),
    );  
  }
}