import CoreLocation
import Flutter
import MapboxDirections
import MapboxMaps
import MapboxNavigationCore
import UIKit

@MainActor
final class NativeMapCoordinator {
    private let navigationMapView: MapboxNavigationCore.NavigationMapView
    private let navigationManager: NavigationManager
    private let onRouteInfoChanged: (([String: Any]) -> Void)?
    private let onContainerSelected: (Int) -> Void
    private lazy var annotationCoordinator = NativeContainerAnnotationCoordinator(
        mapView: navigationMapView.mapView,
        onContainerSelected: onContainerSelected
    )
    private var previewRouteTask: Task<Void, Never>?

    init(
        navigationMapView: MapboxNavigationCore.NavigationMapView,
        navigationManager: NavigationManager,
        onRouteInfoChanged: (([String: Any]) -> Void)?,
        onContainerSelected: @escaping (Int) -> Void
    ) {
        self.navigationMapView = navigationMapView
        self.navigationManager = navigationManager
        self.onRouteInfoChanged = onRouteInfoChanged
        self.onContainerSelected = onContainerSelected
    }

    deinit {
        previewRouteTask?.cancel()
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pingMapView":
            result("iOS map view ready")

        case "setUserLocationEnabled":
            setUserLocationEnabled(call.arguments)
            result(nil)

        case "centerOnUser":
            centerOnUser(call.arguments)
            result(nil)

        case "centerOnCoordinate":
            centerOnCoordinate(call.arguments)
            result(nil)

        case "showDestination":
            showDestination(call.arguments)
            result(nil)

        case "setMapStyle":
            setMapStyle(call.arguments)
            result(nil)

        case "setContainers":
            annotationCoordinator.setContainers(
                NativeMapCommandPayload.containers(from: call.arguments)
            )
            result(nil)

        case "clearContainers":
            annotationCoordinator.clearContainers()
            result(nil)

        case "previewRoute":
            previewRoute(call.arguments)
            result(nil)

        case "clearRoutePreview":
            clearRoutePreview()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func setUserLocationEnabled(_ arguments: Any?) {
        let params = NativeMapCommandPayload.dictionary(from: arguments)
        let enabled = NativeMapCommandPayload.bool(from: params["enabled"]) ?? true

        if enabled {
            navigationMapView.mapView.location.options.puckType = .puck2D(
                .makeDefault(showBearing: true)
            )
            navigationMapView.mapView.location.options.puckBearing = .course
            navigationMapView.mapView.location.options.puckBearingEnabled = true
        } else {
            navigationMapView.mapView.location.options.puckType = nil
        }
    }

    func centerOnUser(_ arguments: Any?) {
        guard let location = navigationManager.currentLocation else {
            emitMapError("No se pudo obtener la ubicación actual")
            return
        }

        let params = NativeMapCommandPayload.dictionary(from: arguments)
        let zoom = NativeMapCommandPayload.double(from: params["zoom"]) ?? 15
        setCamera(center: location.coordinate, zoom: zoom)
    }

    func centerOnCoordinate(_ arguments: Any?) {
        guard let waypoint = waypoint(from: arguments) else {
            emitMapError("Faltan coordenadas para centrar el mapa")
            return
        }

        let params = NativeMapCommandPayload.dictionary(from: arguments)
        let zoom = NativeMapCommandPayload.double(from: params["zoom"]) ?? 15
        setCamera(center: waypoint.coordinate, zoom: zoom)
    }

    func showDestination(_ arguments: Any?) {
        guard let waypoint = waypoint(from: arguments) else {
            emitMapError("Faltan coordenadas para mostrar el destino")
            return
        }

        annotationCoordinator.showDestination(waypoint)
        centerOnCoordinate(arguments)
    }

    func setMapStyle(_ arguments: Any?) {
        let params = NativeMapCommandPayload.dictionary(from: arguments)
        let style = params["style"] as? String
        navigationMapView.mapView.mapboxMap.loadStyle(styleURI(for: style))
    }

    func previewRoute(_ arguments: Any?) {
        let waypoints = NativeMapCommandPayload.waypoints(from: arguments)
        guard let destination = waypoints.last else {
            emitMapError("Falta destino para calcular ruta")
            return
        }

        annotationCoordinator.showDestination(destination)
        previewRouteTask?.cancel()
        previewRouteTask = Task { [weak self] in
            guard let self else { return }

            do {
                let routes = try await navigationManager.calculateRoute(
                    to: destination.coordinate,
                    title: destination.title,
                    profileIdentifier: profileIdentifier(from: arguments)
                )
                await MainActor.run {
                    self.navigationMapView.showcase(
                        routes,
                        routeAnnotationKinds: [],
                        animated: true
                    )
                    self.emitInitialRoute(routes)
                }
            } catch {
                await MainActor.run {
                    self.emitMapError(error.localizedDescription)
                }
            }
        }
    }

    func clearRoutePreview() {
        previewRouteTask?.cancel()
        previewRouteTask = nil
        annotationCoordinator.clearDestination()
    }

    private func waypoint(from arguments: Any?) -> NativeWaypointPayload? {
        NativeWaypointPayload(
            dictionary: NativeMapCommandPayload.dictionary(from: arguments)
        )
    }

    private func setCamera(center: CLLocationCoordinate2D, zoom: Double) {
        navigationMapView.mapView.camera.ease(
            to: CameraOptions(center: center, zoom: zoom),
            duration: 0.35
        )
    }

    private func styleURI(for style: String?) -> StyleURI {
        switch style {
        case "satelliteStreets":
            return .satelliteStreets
        case "dark":
            return .dark
        case "outdoors":
            return .outdoors
        case "standard":
            return .standard
        default:
            return .standard
        }
    }

    private func profileIdentifier(from arguments: Any?) -> ProfileIdentifier {
        let params = NativeMapCommandPayload.dictionary(from: arguments)
        switch params["profile"] as? String {
        case "walking":
            return .walking
        case "cycling":
            return .cycling
        default:
            return .automobile
        }
    }

    private func emitInitialRoute(_ routes: NavigationRoutes) {
        let route = routes.mainRoute.route
        onRouteInfoChanged?([
            "instruction": firstInstruction(in: route) ?? "Ruta calculada",
            "distanceMeters": route.distance,
            "etaSeconds": route.expectedTravelTime,
            "stepIndex": 0,
            "isOffRoute": false
        ])
    }

    private func emitMapError(_ message: String) {
        onRouteInfoChanged?([
            "instruction": message,
            "isOffRoute": false
        ])
    }

    private func firstInstruction(in route: Route) -> String? {
        route.legs
            .flatMap(\.steps)
            .first { !$0.instructions.isEmpty }?
            .instructions
    }
}
