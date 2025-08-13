import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

final TextStyle logo = const TextStyle(
  color: camarone950,
  fontSize: 46,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: sombraNegro,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ],
);

final TextStyle subTitulo = const TextStyle(
  color: camarone950,
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
  color: colorNegro,
  fontSize: 16,
  shadows: [
    Shadow(
      color: camarone100,
      offset: Offset(0, 1),
      blurRadius: 1,
    )
  ]
);

final TextStyle labelInput = const TextStyle(
  color: colorNegro,
  fontSize: 15,
  shadows: [
    Shadow(
      color: sombraNegro,           
      offset: Offset(0, 1),            
      blurRadius: 3,
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

final TextStyle titulo = const TextStyle(
  color: camarone950,
  fontSize: 34,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: sombraNegro,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ],
);

final TextStyle cuerpo = const TextStyle(
  color: camarone950,
  fontSize: 20,
  fontWeight: FontWeight.bold,
    shadows: [
    Shadow(
      color: sombraNegro,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ],
);