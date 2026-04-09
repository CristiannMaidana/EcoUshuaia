import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosNavigationMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? title;

  const IosNavigationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return UiKitView(
      viewType: 'eco_ushuaia/navigation_map_view',
      creationParams: {
        'latitude': latitude,
        'longitude': longitude,
        'title': title,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}