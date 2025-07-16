import 'package:flutter/material.dart';
import 'colores_theme.dart';

//Container decoration para login.
final BoxDecoration containerInputsLogin = BoxDecoration(
  color: camarone500,
  borderRadius: BorderRadius.circular(50), // Rounded corners
  border: Border.all(
    color: camarone600,
    width: 1, // Border width
  ),
  boxShadow: [
    BoxShadow(
      color: camarone950,
      offset: Offset(0, 7),
      blurRadius: 20,
    ),
  ],
);