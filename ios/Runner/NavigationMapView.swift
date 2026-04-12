import Combine
import CoreLocation
import Flutter
import MapboxDirections
import MapboxNavigationCore
import UIKit

final class NavigationMapView: UIView {
    private let destinationCoordinate: CLLocationCoordinate2D
    private let destinationTitle: String?
    private let onRouteInfoChanged: (([String: Any]) -> Void)?

    private let navigationManager: NavigationManager
    private let mapView: MapboxNavigationCore.NavigationMapView
    private var nativeMapCoordinator: NativeMapCoordinator?
    private var cancellables = Set<AnyCancellable>()
    private var routeRequestTask: Task<Void, Never>?
    private var hasRequestedRoute = false

    init(
        frame: CGRect,
        destinationCoordinate: CLLocationCoordinate2D,
        destinationTitle: String?,
        onRouteInfoChanged: (([String: Any]) -> Void)?
    ) {
        let manager = NavigationManager()
        self.navigationManager = manager
        self.mapView = MapboxNavigationCore.NavigationMapView(
            location: manager.locationPublisher,
            routeProgress: manager.routeProgressPublisher,
            predictiveCacheManager: manager.predictiveCacheManager
        )
        self.destinationCoordinate = destinationCoordinate
        self.destinationTitle = destinationTitle
        self.onRouteInfoChanged = onRouteInfoChanged
        super.init(frame: frame)

        setupMap()
        nativeMapCoordinator = NativeMapCoordinator(
            navigationMapView: mapView,
            navigationManager: navigationManager,
            onRouteInfoChanged: onRouteInfoChanged,
            onContainerSelected: { _ in }
        )
        observeNavigation()
        navigationManager.start()
        emitLoading()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        routeRequestTask?.cancel()
    }

    private func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.viewportPadding = UIEdgeInsets(top: 90, left: 24, bottom: 90, right: 24)
        mapView.routeLineTracksTraversal = true
        mapView.showsTrafficOnRouteLine = true
        addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setNativeContainerSelectionHandler(_ handler: @escaping (Int) -> Void) {
        nativeMapCoordinator = NativeMapCoordinator(
            navigationMapView: mapView,
            navigationManager: navigationManager,
            onRouteInfoChanged: onRouteInfoChanged,
            onContainerSelected: handler
        )
    }

    func handleMapCommand(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        nativeMapCoordinator?.handle(call, result: result)
    }

    private func observeNavigation() {
        navigationManager.$currentLocation
            .compactMap { $0 }
            .first()
            .sink { [weak self] _ in
                self?.requestRouteIfNeeded()
            }
            .store(in: &cancellables)

        navigationManager.$routeProgress
            .compactMap { $0 }
            .sink { [weak self] progress in
                self?.emitProgress(progress)
            }
            .store(in: &cancellables)

        navigationManager.$isRerouting
            .removeDuplicates()
            .sink { [weak self] isRerouting in
                if isRerouting {
                    self?.emitRecalculating()
                }
            }
            .store(in: &cancellables)
    }

    private func requestRouteIfNeeded() {
        guard !hasRequestedRoute else { return }
        hasRequestedRoute = true

        routeRequestTask = Task { [weak self] in
            guard let self else { return }

            do {
                let routes = try await navigationManager.calculateRoute(
                    to: destinationCoordinate,
                    title: destinationTitle
                )
                await MainActor.run {
                    self.mapView.showcase(routes, routeAnnotationKinds: [], animated: true)
                    self.emitInitialRoute(routes)
                }
            } catch {
                await MainActor.run {
                    self.emitError(error)
                    print("Route error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func emitLoading() {
        onRouteInfoChanged?([
            "instruction": "Calculando ruta...",
            "isOffRoute": false
        ])
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

    private func emitProgress(_ progress: RouteProgress) {
        let stepProgress = progress.currentLegProgress.currentStepProgress
        let instruction = stepProgress.currentVisualInstruction?.primaryInstruction.text
            ?? stepProgress.step.instructions

        onRouteInfoChanged?([
            "instruction": instruction,
            "distanceMeters": progress.distanceRemaining,
            "etaSeconds": progress.durationRemaining,
            "stepIndex": progress.currentLegProgress.stepIndex,
            "isOffRoute": false
        ])
    }

    private func emitRecalculating() {
        onRouteInfoChanged?([
            "instruction": "Recalculando ruta...",
            "isOffRoute": true
        ])
    }

    private func emitError(_ error: Error) {
        onRouteInfoChanged?([
            "instruction": error.localizedDescription,
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
