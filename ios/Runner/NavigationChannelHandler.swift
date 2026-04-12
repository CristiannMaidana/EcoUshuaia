import CoreLocation
import Flutter
import UIKit

final class NavigationChannelHandler: NSObject {
    private static var navigationChannel: FlutterMethodChannel?

    static func register(with controller: FlutterViewController) {
        registerNavigationMapView(with: controller)
        registerNavigationBridge(with: controller)
    }

    private static func registerNavigationMapView(with controller: FlutterViewController) {
        let factory = NavigationMapViewFactory(
            messenger: controller.binaryMessenger
        )

        registrar(for: controller)?.register(
            factory,
            withId: "eco_ushuaia/navigation_map_view"
        )
    }

    private static func registerNavigationBridge(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "eco_ushuaia/navigation",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak controller] call, result in
            switch call.method {
            case "pingNavigation":
                result("iOS navigation ready")

            case "openNativeNavigation":
                openNativeNavigation(
                    from: controller,
                    arguments: call.arguments,
                    result: result
                )

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        navigationChannel = channel
    }

    private static func openNativeNavigation(
        from controller: FlutterViewController?,
        arguments: Any?,
        result: @escaping FlutterResult
    ) {
        guard let controller else {
            result(FlutterError(
                code: "NO_CONTROLLER",
                message: "No se encontró el controlador de Flutter",
                details: nil
            ))
            return
        }

        guard let params = arguments as? [String: Any],
              let latitude = coordinate(from: params["latitude"]),
              let longitude = coordinate(from: params["longitude"])
        else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Faltan latitude o longitude para abrir navegación",
                details: nil
            ))
            return
        }

        let destination = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let navigationViewController = NavigationViewController(
            destinationCoordinate: destination,
            destinationTitle: params["title"] as? String
        )
        navigationViewController.modalPresentationStyle = .fullScreen

        let presenter = controller.presentedViewController ?? controller
        presenter.present(navigationViewController, animated: true) {
            result(nil)
        }
    }

    private static func registrar(
        for controller: FlutterViewController
    ) -> FlutterPluginRegistrar? {
        controller.registrar(forPlugin: "eco_ushuaia/navigation_map_view")
    }

    private static func coordinate(from value: Any?) -> CLLocationDegrees? {
        if let value = value as? CLLocationDegrees {
            return value
        }

        if let value = value as? NSNumber {
            return value.doubleValue
        }

        return nil
    }
}
