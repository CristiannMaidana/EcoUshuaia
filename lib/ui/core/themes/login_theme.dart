//Este sera el theme principal para la pagina Login, el cual convinara todos los temes necesarios
import 'package:flutter/material.dart';
import 'colores_theme.dart';
import 'texto_theme.dart';

final ThemeData appLoginTheme = ThemeData(
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: verdeBackGround,
  appBarTheme: AppBarTheme(backgroundColor: verdeBackGround),
  textTheme: TextTheme(
    displayLarge: logo,
    headlineLarge: subTitulo,
    //titleLarge: TextStyle(),
    //bodyLarge: TextStyle(),
    labelLarge: labelConTexto,
    labelMedium: labelInput,
    labelSmall: labelDeError,
  ),
);