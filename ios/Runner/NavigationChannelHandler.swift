import Flutter
import UIKit

final class NavigationChannelHandler {

    static func register(with controller: FlutterViewController) {
        let _ = FlutterMethodChannel(
            name: "eco_ushuaia/native_map",
            binaryMessenger: controller.binaryMessenger
        )
    }
}
