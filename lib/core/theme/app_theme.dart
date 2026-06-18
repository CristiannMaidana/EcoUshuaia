import 'package:flutter/material.dart';
import 'theme.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: camarone50,
  appBarTheme: const AppBarTheme(backgroundColor: camarone50),

  // textTheme: TextTheme(
  //   displayLarge: logo,
  //   headlineLarge: subTitulo,
  //   headlineMedium: titulo,
  //   bodyLarge: cuerpo,
  //   labelLarge: labelConTexto,
  //   labelMedium: labelInput,
  //   labelSmall: labelDeError,
  // ),

  inputDecorationTheme: appInputDecorationTheme,

  elevatedButtonTheme: ElevatedButtonThemeData(style: botonEstandar),
  outlinedButtonTheme: OutlinedButtonThemeData(style: buttonSecundary),

);
