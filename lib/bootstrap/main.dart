import 'package:flutter/material.dart';
import 'package:eco_ushuaia/app/app.dart';
import 'package:eco_ushuaia/core/services/mapbox_initializer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxInitializer.ensureInitialized();
  runApp(const App());
}
