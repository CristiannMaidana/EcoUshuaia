import 'package:eco_ushuaia/features/news/presentation/widgets/items_novedades.dart';
import 'package:flutter/material.dart';

class CustomNovedades extends StatefulWidget {
  
  const CustomNovedades({Key? key}) : super(key: key);

  @override
  State<CustomNovedades> createState() => _CustomNovedadesState();
}

class _CustomNovedadesState extends State<CustomNovedades> {
  bool _mostrarFlecha = false;
  ScrollController? _localController;
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  void _scrollListener() {
    if (_localController == null) return;
    if (_localController!.offset > 100 && !_mostrarFlecha) {
      setState(() {
        _mostrarFlecha = true;
      });
    } else if (_localController!.offset <= 100 && _mostrarFlecha) {
      setState(() {
        _mostrarFlecha = false;
      });
    }
  }

  void _subirTodo() {
    if (_localController != null) {
      _localController!.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _bajarSheet() {
    // Esto mueve la sheet al tamaño inicial (ejemplo: 0.4)
    _draggableController.animateTo(
      0.4,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _localController?.removeListener(_scrollListener);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _bajarSheet,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              if (_localController != scrollController) {
                _localController?.removeListener(_scrollListener);
                _localController = scrollController;
                _localController!.addListener(_scrollListener);
              }
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            ItemsNovedades(listaNovedades: [],),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_mostrarFlecha)
            Positioned(
              right: 24,
              bottom: 48,
              child: FloatingActionButton(
                backgroundColor: Colors.black.withOpacity(0.8),
                mini: true,
                onPressed: _subirTodo,
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 32),
              ),
            ),
        ],
      ),
    );
  }
}