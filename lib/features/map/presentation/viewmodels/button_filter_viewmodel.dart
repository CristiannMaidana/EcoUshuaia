import 'package:flutter/material.dart';

class ButtonFilterViewmodel extends ChangeNotifier{
  final Set<String> _selected = {};

  // Metodo para obtener el elemento
  Set<String> get selected => _selected;

  // Map de ids de botones filtros
  final Map<dynamic, List<int>> _filtros = {};
  Map<dynamic, List<int>> get filtros => _filtros;


  // Obtener el valor boolean para cambiar el color del estado del boton
  bool isSelected(String boton) => _selected.contains(boton);

  // Metodo para agrega o quita el boton seleccionado y actualizar el estado
  void toggle(String boton, dynamic tipoBoton, List<int> ids){
    if (_selected.contains(boton)){
      _selected.remove(boton);
      removeIdFilter(tipoBoton, ids);
    }
    else {
      _selected.add(boton);
      addIdsFilter(tipoBoton, ids);
    }
    notifyListeners();
  }

  // Metodo para limpiar todos los filtros y actualizar el estado
  void clean(){
    _selected.clear();
    _filtros.clear();
    notifyListeners();
  }

  // Metodo con id caracteristico de boton mas ids de filtros, agrega en un case de a 1 el add
  void addIdsFilter(dynamic tipoBoton, List<int> ids){
      for(int id in ids){
        _filtros.putIfAbsent(tipoBoton, () => []).add(id);
      }
  }

  // Metodo para eliminar ids de botones seleccionados
  void removeIdFilter(dynamic tipoBoton, List<int> idAEliminar) {
    final list = _filtros[tipoBoton];
    if (list == null) return;

    if (idAEliminar.isEmpty) {
      list.clear();
    } else {
      final removeSet = idAEliminar.toSet();
      list.removeWhere(removeSet.contains);
    }

    if (list.isEmpty) {
      _filtros.remove(tipoBoton);
    }
  }
}