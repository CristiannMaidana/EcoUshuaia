import 'package:flutter/material.dart';
import 'colors.dart';

final ButtonStyle botonEstandar = ElevatedButton.styleFrom(
  backgroundColor: camarone600,
  foregroundColor: camarone50,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  side: BorderSide(
    color: camarone700,
    width: 1,
  ),
  shadowColor: camarone950,
  elevation: 5,
);