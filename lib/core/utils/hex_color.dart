import 'package:flutter/material.dart';

/// Convierte "#RRGGBB", "RRGGBB", o "#RGB" a Color (
class HexColor {
  static Color from(String hex) {
    var v = hex.trim();
    if (v.startsWith('#')) v = v.substring(1);
    if (v.length == 3) {
      // "#RGB" → "#RRGGBB"
      v = v.split('').map((c) => '$c$c').join();
    }
    if (v.length == 6) v = 'FF$v';
    if (v.length != 8) {
      throw FormatException('Color inválido: $hex');
    }
    return Color(int.parse(v, radix: 16));
  }
}

// Utilizacion de la clase como extension
extension HexColorX on String {
  Color toColor() => HexColor.from(this);
}