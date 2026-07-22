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
        case "centerOnCoordinate":
            centerOnCoordinate(arguments: call.arguments, result: result)
        case "getCameraCenter":
            getCameraCenter(result: result)
        case "setMapStyle":
            setMapStyle(arguments: call.arguments, result: result)
        case "updatePreviewSheetInset":
            updatePreviewSheetInset(arguments: call.arguments, result: result)
        case "showDestinationPreview":
            showDestinationPreview(arguments: call.arguments, result: result)
        case "clearDestinationPreview":
            mapView?.clearDestinationPreview()
            result(["event": "destinationPreviewCleared"])
        case "setZones":
            setZones(arguments: call.arguments, result: result)
        case "clearZones":
            mapView?.clearZones()
            result(["event": "zonesCleared"])
        case "hideZones":
            hideZones(arguments: call.arguments, result: result)
        case "showAllZones":
            showAllZones(arguments: call.arguments, result: result)
        case "showMyZone":
            showMyZone(arguments: call.arguments, result: result)
        case "showAffectedZones":
            showAffectedZones(arguments: call.arguments, result: result)
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
        mapView?.clearDestinationPreview()

        do {
            let payload = try await runtime.navigationCore.calculatePreviewRoute(
                coordinates: points,
                profileIdentifier: profileIdentifier
            )

            mapView?.releaseTurnByTurnCameraLock()

            if let routes = runtime.navigationCore.currentNavigationRoutes {
                mapView?.showRoute(routes)
                mapView?.startPreviewOverviewMode()
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
            mapView?.stopPreviewOverviewMode()
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
        mapView?.clearDestinationPreview()
        mapView?.stopPreviewOverviewMode()
        mapView?.resetAfterNavigationCancel()
        mapView?.resetCameraToIdle()

        channel.invokeMethod("onNavigationStateChanged", arguments: payload)
        result(payload)
    }

    private func centerTurnByTurnCamera(result: @escaping FlutterResult) {
        mapView?.centerTurnByTurnCamera(restrictZoomOut: false)
        result([
            "event": "navigationCameraCentered",
            "cameraState": "following"
        ])
    }

    private func centerOnCoordinate(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let latitude = Self.doubleValue(args["latitude"]),
              let longitude = Self.doubleValue(args["longitude"]) else {
            result(FlutterError(code: "invalid_camera_args", message: "Camera center arguments are invalid.", details: nil))
            return
        }

        let zoom = Self.doubleValue(args["zoom"]) ?? 15
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView?.centerOnCoordinate(coordinate, zoom: zoom)
        result([
            "event": "cameraCentered",
            "latitude": latitude,
            "longitude": longitude
        ])
    }

    private func getCameraCenter(result: @escaping FlutterResult) {
        guard let coordinate = mapView?.cameraCenterCoordinate else {
            result(nil)
            return
        }

        result([
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ])
    }

    private func showDestinationPreview(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let latitude = Self.doubleValue(args["latitude"]),
              let longitude = Self.doubleValue(args["longitude"]) else {
            result(FlutterError(code: "invalid_destination_preview_args", message: "Destination preview arguments are invalid.", details: nil))
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView?.showDestinationPreview(at: coordinate)
        result([
            "event": "destinationPreviewShown",
            "latitude": latitude,
            "longitude": longitude
        ])
    }

    private func updatePreviewSheetInset(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let height = Self.doubleValue(args["height"]),
              let state = args["state"] as? String else {
            result(FlutterError(code: "invalid_preview_sheet_args", message: "Preview sheet arguments are invalid.", details: nil))
            return
        }

        mapView?.updatePreviewSheetInset(CGFloat(height), state: state)
        result([
            "event": "previewSheetInsetUpdated",
            "height": height,
            "state": state
        ])
    }

    private func setZones(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let rawZones = args["zones"] as? [[String: Any]] else {
            result(FlutterError(code: "invalid_zones_args", message: "Zones payload is invalid.", details: nil))
            return
        }

        let zones = rawZones.compactMap(ZonePolygonPayload.init(dictionary:))
        mapView?.setZones(zones)
        result([
            "event": "zonesUpdated",
            "count": zones.count
        ])
    }

    private func hideZones(arguments: Any?, result: @escaping FlutterResult) {
        mapView?.hideZones(sheetBottomInset: zoneSheetHeight(arguments: arguments))
        result(["event": "zonesHidden"])
    }

    private func showAllZones(arguments: Any?, result: @escaping FlutterResult) {
        mapView?.showAllZones(sheetBottomInset: zoneSheetHeight(arguments: arguments))
        result(["event": "allZonesShown"])
    }

    private func showMyZone(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let zoneId = Self.intValue(args["zoneId"] ?? args["idZona"] ?? args["id_zona"]) else {
            result(FlutterError(code: "invalid_my_zone_args", message: "My zone arguments are invalid.", details: nil))
            return
        }

        mapView?.showMyZone(zoneId, sheetBottomInset: zoneSheetHeight(arguments: arguments))
        result([
            "event": "myZoneShown",
            "zoneId": zoneId
        ])
    }

    private func showAffectedZones(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let rawZoneIds = args["zoneIds"] as? [Any] ?? args["zonesIds"] as? [Any] ?? args["idsZona"] as? [Any] else {
            result(FlutterError(code: "invalid_affected_zones_args", message: "Affected zones arguments are invalid.", details: nil))
            return
        }

        let zoneIds = rawZoneIds.compactMap(Self.intValue)
        let activeZoneId = Self.intValue(args["activeZoneId"] ?? args["active_zone_id"])
        mapView?.showAffectedZones(zoneIds, activeZoneId: activeZoneId)
        result([
            "event": "affectedZonesShown",
            "zoneIds": zoneIds,
            "activeZoneId": activeZoneId as Any
        ])
    }

    private func zoneSheetHeight(arguments: Any?) -> CGFloat? {
        guard let args = arguments as? [String: Any],
              let sheetHeight = Self.doubleValue(args["sheetHeight"]) else {
            return nil
        }
        return CGFloat(max(0, sheetHeight))
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

    private func routeCoordinates(arguments: Any?) -> [CLLocationCoordinate2D]? {
        guard let args = arguments as? [String: Any] else {
            return nil
        }

        if let rawPoints = args["routePoints"] as? [[String: Any]] {
            let points = rawPoints.compactMap { point -> CLLocationCoordinate2D? in
                guard let latitude = Self.doubleValue(point["lat"]),
                      let longitude = Self.doubleValue(point["lon"]) else {
                    return nil
                }
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            if points.count == rawPoints.count && points.count >= 2 {
                return points
            }
        }

        guard let originLatitude = Self.doubleValue(args["originLatitude"]),
              let originLongitude = Self.doubleValue(args["originLongitude"]),
              let destinationLatitude = Self.doubleValue(args["destinationLatitude"]),
              let destinationLongitude = Self.doubleValue(args["destinationLongitude"]) else {
            return nil
        }

        return [
            CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude),
            CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        ]
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

    private static func intValue(_ value: Any?) -> Int? {
        if let int = value as? Int {
            return int
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        return nil
    }
}
