import 'package:flutter/material.dart';

class ButtonFilterViewmodel extends ChangeNotifier{
  final Set<String> _selected = {};

  // Metodo para obtener el elemento
  Set<String> get selected => _selected;

  // Obtener el valor boolean para cambiar el color del estado del boton
  bool isSelected(String boton) => _selected.contains(boton);

  // TODO: crear metodo para agrega o quita el boton seleccionado para actualizar el estado

  // TODO: crear metodo para limpiar todos los filtros
}