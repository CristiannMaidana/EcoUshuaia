import CoreLocation
import UIKit
import MapboxNavigationCore
import MapboxNavigationUIKit

final class NativeMapView: UIView {

    private let navigationProvider: MapboxNavigationProvider
    private let navigationMapView: NavigationMapView
    private let navigationCore: NavigationCoreNative

    override init(frame: CGRect) {
        self.navigationProvider = MapboxNavigationProvider(
            coreConfig: .init(
                locationSource: .simulation()
            )
        )

        let navigation = navigationProvider.navigation()

        self.navigationMapView = NavigationMapView(
            location: navigation.locationMatching
                .map(\.mapMatchingResult.enhancedLocation)
                .eraseToAnyPublisher(),
            routeProgress: navigation.routeProgress
                .map(\.?.routeProgress)
                .eraseToAnyPublisher(),
            heading: navigation.heading,
            predictiveCacheManager: navigationProvider.predictiveCacheManager
        )

        self.navigationCore = NavigationCoreNative(
            navigationProvider: navigationProvider
        )

        super.init(frame: frame)

        setupMap()
        buildInitialRoute()
    }

    required init?(coder: NSCoder) {
        self.navigationProvider = MapboxNavigationProvider(
            coreConfig: .init(
                locationSource: .simulation()
            )
        )

        let navigation = navigationProvider.navigation()

        self.navigationMapView = NavigationMapView(
            location: navigation.locationMatching
                .map(\.mapMatchingResult.enhancedLocation)
                .eraseToAnyPublisher(),
            routeProgress: navigation.routeProgress
                .map(\.?.routeProgress)
                .eraseToAnyPublisher(),
            heading: navigation.heading,
            predictiveCacheManager: navigationProvider.predictiveCacheManager
        )

        self.navigationCore = NavigationCoreNative(
            navigationProvider: navigationProvider
        )

        super.init(coder: coder)

        setupMap()
        buildInitialRoute()
    }

    private func setupMap() {
        navigationMapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigationMapView)

        NSLayoutConstraint.activate([
            navigationMapView.topAnchor.constraint(equalTo: topAnchor),
            navigationMapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationMapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationMapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func buildInitialRoute() {
        let origin = CLLocationCoordinate2D(latitude: -54.8272, longitude: -68.3385)
        let destination = CLLocationCoordinate2D(latitude: -54.8061, longitude: -68.3038)

        navigationCore.buildPreviewRoute(origin: origin, destination: destination) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let navigationRoutes):
                    self.showRoute(navigationRoutes)
                }
            }
        }
    }

    func showRoute(_ navigationRoutes: NavigationRoutes) {
        navigationMapView.showcase(navigationRoutes, animated: false)
    }
}
