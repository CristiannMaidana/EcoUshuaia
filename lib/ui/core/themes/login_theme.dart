//Este sera el theme principal para la pagina Login, el cual convinara todos los temes necesarios
import 'package:eco_ushuaia/ui/core/themes/botones_theme.dart';
import 'package:flutter/material.dart';
import 'colores_theme.dart';
import 'texto_theme.dart';
import 'inputs_theme.dart';

final ThemeData appLoginTheme = ThemeData(
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: camarone300,
  appBarTheme: AppBarTheme(backgroundColor: camarone300),
  textTheme: TextTheme(
    displayLarge: logo,
    headlineLarge: subTitulo,
    //titleLarge: TextStyle(),
    //bodyLarge: TextStyle(),
    labelLarge: labelConTexto,
    labelMedium: labelInput,
    labelSmall: labelDeError,
  ),
  inputDecorationTheme:appInputDecorationTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(style: botonEstandar),
);