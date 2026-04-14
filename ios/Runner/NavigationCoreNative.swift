import CoreLocation
import Foundation
import MapboxNavigationCore

final class NavigationCoreNative {
    private let navigationProvider: MapboxNavigationProvider

    init(navigationProvider: MapboxNavigationProvider) {
        self.navigationProvider = navigationProvider
    }

    @MainActor func buildPreviewRoute(
        origin: CLLocationCoordinate2D,
        destination: CLLocationCoordinate2D,
        completion: @escaping (Result<NavigationRoutes, Error>) -> Void
    ) {
        let options = NavigationRouteOptions(coordinates: [origin, destination])
        let request = navigationProvider.routingProvider().calculateRoutes(options: options)

        Task {
            switch await request.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let navigationRoutes):
                completion(.success(navigationRoutes))
            }
        }
    }
}
