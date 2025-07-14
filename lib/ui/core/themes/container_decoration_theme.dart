import 'package:flutter/material.dart';
import 'colores_theme.dart';

//Container decoration para login.
final BoxDecoration containerInputsLogin = BoxDecoration(
  color: verdeLoginContainer,
  borderRadius: BorderRadius.circular(50), // Rounded corners
  border: Border.all(
    color: Color.fromRGBO(10, 20, 13, 0.498),
    width: 1, // Border width
  ),
  boxShadow: [
    BoxShadow(
      color: sombraNegro,
      offset: Offset(0, 7),
      blurRadius: 20,
    ),
  ],
);