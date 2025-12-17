import 'package:eco_ushuaia/features/map/presentation/widgets/content_filter.dart';
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
  static double _bottomNavBar = 10;

  // factor 0..1 según altura actual; si no está attachado, usá 0 (colapsado)
  double get _t {
    if (!(_controller.isAttached)) return 0.0;
    final s = _controller.size;
    final v = (s - _min) / (_max - _min);
    return v.clamp(0.0, 1.0);
  }

  double _mix(double a, double b, double t) => a + (b - a) * t;


  void _onSheetChange() {
    if (!mounted) return;
    setState(() {
      _setBottom();
    }); //Rebuild para reflejar el cambio de tamaño del controller
  }

  void _setBottom() {
    if (_controller.size == _max) {
      _bottomNavBar = 0;
    }
    if (_controller.size == _min){
      _bottomNavBar = 10;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController()..addListener(_onSheetChange);// Agregar listener para escuchar el cambio
    _bottomNavBar = 10;
  }

  // Manejo de altura desde incio
  void _dragFromHeader(DragUpdateDetails d) {
    if (!(_controller.isAttached)) return;
    final h = MediaQuery.of(context).size.height;
    final next = (_controller.size - d.delta.dy / h).clamp(_min, _max);
    _controller.jumpTo(next);
  }

    // Manejo de altura para arrastre
  void _endDragFromHeader(DragEndDetails d) {
    if (!(_controller.isAttached)) return;
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
    final double animatedBottom = _mix(_bottom, 0, _t);
    final double animatedBorde  = _mix(_borde, 0, _t);

    return AnimatedPadding(
      duration: Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(16, 0, 16, animatedBottom),
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: _min,
        minChildSize: _min,
        maxChildSize: _max,
        builder: (context, scrollController) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(top: 5, bottom: _bottomNavBar),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(animatedBorde)),
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
                  child: LayoutBuilder(
                    builder: (context, viewport) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        physics: ClampingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewport.maxHeight,
                          ),
                          child: ContentFilter(),
                        ),
                      );
                    },
                  ),
                ),
              ]
            )
          );
        }
      ),
    );  
  }
}