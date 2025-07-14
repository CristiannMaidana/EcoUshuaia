import 'package:flutter/material.dart';
import 'colores_theme.dart';

final ButtonStyle botonEstandar = ElevatedButton.styleFrom(
  backgroundColor: colorBotonesEstandar,
  foregroundColor: textoBotones,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  side: BorderSide(
    color: borderBotonesEstandar,
    width: .5,
  ),
  shadowColor: sombraNegro,
  elevation: 1,
  minimumSize: const Size(150, 50),
);