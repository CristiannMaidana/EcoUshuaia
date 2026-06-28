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
    width: .5,
  ),
);

final ButtonStyle buttonSecundary = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  side: BorderSide(
    color: Colors.grey[200]!,
    width: 1.3,
  ),
);
