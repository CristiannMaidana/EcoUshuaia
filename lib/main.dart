import 'package:eco_ushuaia/ui/core/themes/login_theme.dart';
import 'package:eco_ushuaia/ui/features/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appLoginTheme,
      home: LoginScreen(),
    );
  }
}