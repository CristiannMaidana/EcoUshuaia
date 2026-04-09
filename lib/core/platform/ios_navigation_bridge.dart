import 'package:flutter/services.dart';

class IosNavigationBridge {
  static const MethodChannel _channel = MethodChannel('eco_ushuaia/navigation');

  static Future<String?> ping() async {
    return await _channel.invokeMethod<String>('pingNavigation');
  }

  static Future<void> openNativeNavigation() async {
    await _channel.invokeMethod('openNativeNavigation');
  } 
}