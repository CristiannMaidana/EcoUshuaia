import 'package:flutter/material.dart';

class ButtonFilterViewmodel extends ChangeNotifier{
  final Set<String> _selected = {};

  // Metodo para obtener el elemento
  Set<String> get selected => _selected;

  // Map de ids de botones filtros
  final Map<int, List<int>> _filtros = {};
  Map<int, List<int>> get filtros => _filtros;


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

  // Metodo para limpiar todos los filtros y actualizar el estado
  void clean(){
    _selected.clear();
    notifyListeners();
  }

  //Metodo con id caracteristico de boton mas ids de filtros, agrega en un case de a 1 el add
  void addIdsFilter(int tipoBoton, int ids){
    if (tipoBoton >= 1 && tipoBoton <= 4) {
      filtros.putIfAbsent(tipoBoton, () => []).add(ids);
    }
  }

  //TODO: crear metodo para eliminar ids de botones seleccionados
}