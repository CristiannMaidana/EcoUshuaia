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
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            border: Border.all(color: Colors.grey[400]!, width: 1.5),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}