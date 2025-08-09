import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomMapa extends StatefulWidget{
  
  CustomMapa({
    Key? key,
  }): super (key: key);

  @override
  State<CustomMapa> createState() => _CustomMapaState();
}

class _CustomMapaState extends State<CustomMapa> with SingleTickerProviderStateMixin{
  late final String accessToken;

  @override
  void initState() {
    super.initState();
    accessToken = const String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget();
  }
}