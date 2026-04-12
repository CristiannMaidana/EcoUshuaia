import Combine
import CoreLocation
import Foundation
import MapboxDirections
import MapboxNavigationCore

enum NavigationManagerError: LocalizedError {
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .locationUnavailable:
            return "No se pudo obtener la ubicación actual"
        }
    }
}

@MainActor
final class NavigationManager {
    private static let sharedProvider = MapboxNavigationProvider(
        coreConfig: CoreConfig(locationSource: .live)
    )

    private let provider: MapboxNavigationProvider
    private var routeTask: RoutingProvider.FetchTask?
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var routeProgress: RouteProgress?
    @Published private(set) var isRerouting = false

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        $currentLocation
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    var routeProgressPublisher: AnyPublisher<RouteProgress?, Never> {
        $routeProgress.eraseToAnyPublisher()
    }

    var predictiveCacheManager: PredictiveCacheManager? {
        provider.predictiveCacheManager
    }

    var mapboxNavigation: MapboxNavigation {
        provider.mapboxNavigation
    }

    var routeVoiceController: RouteVoiceController {
        provider.routeVoiceController
    }

    init(provider: MapboxNavigationProvider? = nil) {
        self.provider = provider ?? NavigationManager.sharedProvider
        observeNavigation()
    }

    deinit {
        routeTask?.cancel()
    }

    func start() {
        provider.tripSession().startFreeDrive()
    }

    func stop() {
        routeTask?.cancel()
        provider.tripSession().setToIdle()
    }

    func eventsManager() -> NavigationEventsManager {
        provider.eventsManager()
    }

    func calculateRoute(
        to destination: CLLocationCoordinate2D,
        title: String?,
        profileIdentifier: ProfileIdentifier = .automobile
    ) async throws -> NavigationRoutes {
        guard let originLocation = currentLocation else {
            throw NavigationManagerError.locationUnavailable
        }

        var origin = Waypoint(location: originLocation)
        if originLocation.course >= 0 {
            origin.heading = originLocation.course
            origin.headingAccuracy = 90
        }

        let destination = Waypoint(coordinate: destination, name: title)
        let options = NavigationRouteOptions(
            waypoints: [origin, destination],
            profileIdentifier: profileIdentifier
        )

        routeTask?.cancel()
        let request = provider.routingProvider().calculateRoutes(options: options)
        routeTask = request

        let routes = try await request.value
        provider.tripSession().startActiveGuidance(with: routes, startLegIndex: 0)
        return routes
    }

    private func observeNavigation() {
        provider.navigation().locationMatching
            .map { $0.enhancedLocation }
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentLocation)

        provider.navigation().routeProgress
            .map { $0?.routeProgress }
            .receive(on: DispatchQueue.main)
            .assign(to: &$routeProgress)

        provider.navigation().rerouting
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status.event {
                case is ReroutingStatus.Events.FetchingRoute:
                    self?.isRerouting = true
                default:
                    self?.isRerouting = false
                }
            }
            .store(in: &cancellables)
    }
}
