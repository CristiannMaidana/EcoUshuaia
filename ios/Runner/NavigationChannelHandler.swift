import Flutter
import UIKit
import CoreLocation

final class NavigationChannelHandler: NSObject {
    static func register(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "eco_ushuaia/navigation",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "pingNavigation":
                result("iOS nativo conectado")

            case "openNativeNavigation":
                guard
                    let args = call.arguments as? [String: Any],
                    let latitude = args["latitude"] as? CLLocationDegrees,
                    let longitude = args["longitude"] as? CLLocationDegrees
                else {
                    result(FlutterError(
                        code: "INVALID_ARGS",
                        message: "Faltan latitude/longitude",
                        details: nil
                    ))
                    return
                }

                let destination = CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                )

                let vc = NavigationViewController(destinationCoordinate: destination)
                vc.modalPresentationStyle = .fullScreen
                controller.present(vc, animated: true)
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
