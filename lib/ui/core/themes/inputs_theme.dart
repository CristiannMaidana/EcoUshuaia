// inputs_theme.dart
import 'package:flutter/material.dart';
import 'colores_theme.dart'; // Importá tus colores personalizados

final InputDecorationTheme appInputDecorationTheme = InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  contentPadding: EdgeInsets.all(20),
  fillColor: camarone50,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(
      color: azulBrillante,
      width: 1.5,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: sombraNegro, width: 1),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(
      color: rojoError,
      width: 1.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(
      color: rojoError,
      width: 1.5,
    ),
  ),
  errorMaxLines: 10,
);