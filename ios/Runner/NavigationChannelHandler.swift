import CoreLocation
import Flutter
import MapboxDirections
import UIKit

@MainActor
final class NavigationChannelHandler {
    private static let channelPrefix = "eco_ushuaia/mapbox_navigation_map_view"

    private let channel: FlutterMethodChannel
    private let runtime: NativeMapRuntime
    private weak var mapView: NativeMapView?

    static func register(with registry: FlutterPluginRegistry) {
        guard let registrar = registry.registrar(forPlugin: "MapboxNavigationMapViewPlugin") else {
            return
        }

        registrar.register(
            MapboxNavigationMapViewFactory(binaryMessenger: registrar.messenger()),
            withId: MapboxNavigationMapViewFactory.viewType
        )
    }

    init(
        viewId: Int64,
        binaryMessenger: FlutterBinaryMessenger,
        runtime: NativeMapRuntime,
        mapView: NativeMapView
    ) {
        self.runtime = runtime
        self.mapView = mapView
        self.channel = FlutterMethodChannel(
            name: "\(Self.channelPrefix)/\(viewId)",
            binaryMessenger: binaryMessenger
        )

        bindNativeEvents()
        bindFlutterMethods()
    }

    private func bindNativeEvents() {
        runtime.navigationCore.onRouteProgressPayload = { [weak self] payload in
            self?.channel.invokeMethod("onRouteProgress", arguments: payload)
        }

        runtime.navigationCore.onNavigationStatePayload = { [weak self] payload in
            self?.channel.invokeMethod("onNavigationStateChanged", arguments: payload)
        }

        runtime.navigationCore.onErrorPayload = { [weak self] payload in
            self?.channel.invokeMethod("onNavigationError", arguments: payload)
        }
    }

    private func bindFlutterMethods() {
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterError(code: "native_map_unavailable", message: "Native map is not available.", details: nil))
                return
            }

            Task { @MainActor in
                await self.handle(call, result: result)
            }
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) async {
        switch call.method {
        case "previewRoute":
            await previewRoute(arguments: call.arguments, result: result)
        case "startNavigation":
            startNavigation(result: result)
        case "cancelNavigation":
            cancelNavigation(result: result)
        case "centerTurnByTurnCamera":
            centerTurnByTurnCamera(result: result)
        case "setMapStyle":
            setMapStyle(arguments: call.arguments, result: result)
        case "getNavigationState":
            result(runtime.navigationCore.currentPayload())
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func previewRoute(arguments: Any?, result: @escaping FlutterResult) async {
        guard let points = routeCoordinates(arguments: arguments) else {
            result(FlutterError(code: "invalid_route_args", message: "Route coordinates are invalid.", details: nil))
            return
        }

        let profileIdentifier = routeProfile(arguments: arguments)

        do {
            let payload = try await runtime.navigationCore.calculatePreviewRoute(
                origin: points.origin,
                destination: points.destination,
                profileIdentifier: profileIdentifier
            )

            mapView?.releaseTurnByTurnCameraLock()

            if let routes = runtime.navigationCore.currentNavigationRoutes {
                mapView?.showRoute(routes)
            }

            channel.invokeMethod("onRoutePreviewed", arguments: payload)
            result(payload)
        } catch {
            let payload = errorPayload(error)
            channel.invokeMethod("onNavigationError", arguments: payload)
            result(FlutterError(code: "route_preview_failed", message: error.localizedDescription, details: payload))
        }
    }

    private func startNavigation(result: @escaping FlutterResult) {
        do {
            let payload = try runtime.navigationCore.startNavigation()
            mapView?.followActiveNavigation()
            channel.invokeMethod("onNavigationStateChanged", arguments: payload)
            result(payload)
        } catch {
            let payload = errorPayload(error)
            channel.invokeMethod("onNavigationError", arguments: payload)
            result(FlutterError(code: "start_navigation_failed", message: error.localizedDescription, details: payload))
        }
    }

    private func cancelNavigation(result: @escaping FlutterResult) {
        let payload = runtime.navigationCore.cancelNavigation()
        mapView?.resetAfterNavigationCancel()

        channel.invokeMethod("onNavigationStateChanged", arguments: payload)
        result(payload)
    }

    private func centerTurnByTurnCamera(result: @escaping FlutterResult) {
        mapView?.centerTurnByTurnCamera()
        result([
            "event": "navigationCameraCentered",
            "cameraState": "following"
        ])
    }

    private func setMapStyle(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let styleIdentifier = args["style"] as? String else {
            result(FlutterError(code: "invalid_style_args", message: "Map style arguments are invalid.", details: nil))
            return
        }

        mapView?.setMapStyle(styleIdentifier)
        result([
            "event": "mapStyleChanged",
            "style": styleIdentifier
        ])
    }

    private func routeCoordinates(arguments: Any?) -> (origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D)? {
        guard let args = arguments as? [String: Any],
              let originLatitude = Self.doubleValue(args["originLatitude"]),
              let originLongitude = Self.doubleValue(args["originLongitude"]),
              let destinationLatitude = Self.doubleValue(args["destinationLatitude"]),
              let destinationLongitude = Self.doubleValue(args["destinationLongitude"]) else {
            return nil
        }

        return (
            origin: CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude),
            destination: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        )
    }

    private func routeProfile(arguments: Any?) -> ProfileIdentifier {
        guard let args = arguments as? [String: Any],
              let rawProfile = args["profile"] as? String else {
            return .automobile
        }

        switch rawProfile {
        case "walking":
            return .walking
        case "cycling":
            return .cycling
        default:
            return .automobile
        }
    }

    private func errorPayload(_ error: Error) -> [String: Any] {
        [
            "event": "navigationError",
            "message": error.localizedDescription
        ]
    }

    private static func doubleValue(_ value: Any?) -> Double? {
        if let double = value as? Double {
            return double
        }
        if let int = value as? Int {
            return Double(int)
        }
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        return nil
    }
}
