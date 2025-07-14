//Theme para los diferentes tipos de textos
import 'package:flutter/material.dart';

final TextStyle logo = const TextStyle(
  color: Colors.white,
  fontSize: 46,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ],
);

final TextStyle subTitulo = const TextStyle(
  color: Color.fromRGBO(233, 233, 240, 1),
  fontSize: 26,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black26,
      offset: Offset(0, 1.35),
      blurRadius: 5,
    ),
  ],
);

final TextStyle labelConTexto = const TextStyle(
  color: Color.fromRGBO(108, 108, 112, 1),
  fontSize: 20,
  shadows: [
    Shadow(
      color: Colors.black87,
      offset: Offset(0, 1),
      blurRadius: 1,
    )
  ]
);

final TextStyle labelInput = const TextStyle(
  color: Color.fromRGBO(28, 28, 30, 1),
  fontSize: 16,
  shadows: [
    Shadow(
      color: Colors.black54,           // sombra oscura pero semi-transparente
      offset: Offset(0, 1),            // sombra cerca del texto, no tan lejos
      blurRadius: 3,                   // desenfoque suave
    ),
  ],
);

final TextStyle labelDeError = const TextStyle(
  color: Colors.red,
  fontSize: 14, 
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.grey,
      offset: Offset(0, 1),
      blurRadius: 5,
    )
  ]
);