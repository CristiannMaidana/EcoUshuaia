import 'package:eco_ushuaia/features/news/presentation/widgets/items_novedades.dart';
import 'package:flutter/material.dart';

class CustomNovedades extends StatefulWidget {
  const CustomNovedades({Key? key}) : super(key: key);

  @override
  State<CustomNovedades> createState() => _CustomNovedadesState();
}

class _CustomNovedadesState extends State<CustomNovedades> {
  static const double _initialChildSize = 0.4;
  static const double _minChildSize = 0.4;
  static const double _maxChildSize = 0.8;
  static const double _epsilon = 0.01;

  bool _mostrarFlecha = false;
  bool _isExpanded = false;
  ScrollController? _localController;
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();

    _draggableController.addListener(() {
      final size = _draggableController.size; 
      final expanded = size > (_initialChildSize + _epsilon);
      if (expanded != _isExpanded) {
        setState(() => _isExpanded = expanded);
      }
    });
  }

  void _scrollListener() {
    if (_localController == null) return;
    if (_localController!.offset > 100 && !_mostrarFlecha) {
      setState(() => _mostrarFlecha = true);
    } else if (_localController!.offset <= 100 && _mostrarFlecha) {
      setState(() => _mostrarFlecha = false);
    }
  }

  Future<void> _resetAndCollapse() async {
    if (_localController != null) {
      try {
        await _localController!.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (_) {
      }
      if (mounted && _mostrarFlecha) {
        setState(() => _mostrarFlecha = false);
      }
    }

    try {
      await _draggableController.animateTo(
        _initialChildSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (_) {
    }
  }

  void _bajarSheet() {
    _draggableController.animateTo(
      _initialChildSize,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _localController?.removeListener(_scrollListener);
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _resetAndCollapse,
              child: Container(
                color: Colors.black.withOpacity(0.07),
              ),
            ),
          ),

        DraggableScrollableSheet(
          controller: _draggableController,
          initialChildSize: _initialChildSize,
          minChildSize: _minChildSize,
          maxChildSize: _maxChildSize,
          builder: (context, scrollController) {
            if (_localController != scrollController) {
              _localController?.removeListener(_scrollListener);
              _localController = scrollController;
              _localController!.addListener(_scrollListener);
            }
            return SafeArea(
              top: false,
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
                    // Handler superior: tap para colapsar a tamaño inicial
                    GestureDetector(
                      onTap: _bajarSheet,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          ItemsNovedades(listaNovedades: const[]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // --- Botón flotante para subir arriba cuando hay scroll hacia abajo ---
        if (_mostrarFlecha)
          Positioned(
            right: 24,
            bottom: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.black.withOpacity(0.8),
              mini: true,
              onPressed: _resetAndCollapse,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 32),
            ),
          ),
      ],
    );
  }
}
