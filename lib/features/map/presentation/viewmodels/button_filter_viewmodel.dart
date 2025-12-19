import 'package:flutter/material.dart';

class ButtonFilterViewmodel extends ChangeNotifier{
  final Set<String> _selected = {};

  // Metodo para obtener el elemento
  Set<String> get selected => _selected;

  // Obtener el valor boolean para cambiar el color del estado del boton
  bool isSelected(String boton) => _selected.contains(boton);

  // Metodo para agrega o quita el boton seleccionado y actualizar el estado
  void toggle(String boton){
    if (_selected.contains(boton)){
      _selected.remove(boton);
    }
    else {
      _selected.add(boton);
    }
    notifyListeners();
  }

  // TODO: crear metodo para limpiar todos los filtros
}