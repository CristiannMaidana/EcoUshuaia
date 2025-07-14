import 'package:flutter/material.dart';
import 'colores_theme.dart';

final ButtonStyle botonEstandar = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(217, 22, 193, 22),
  foregroundColor: textoBotones,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  side: BorderSide(
    color: const Color.fromARGB(255, 8, 73, 10),
    width: .5,
  ),
  shadowColor: sombraNegro,
  elevation: 1,
  minimumSize: const Size(150, 50),
);