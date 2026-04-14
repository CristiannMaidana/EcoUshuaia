import UIKit
import Combine
import CoreLocation
import MapboxNavigationCore
import MapboxNavigationUIKit

final class NativeMapView: UIView {

    private let navigationProvider: MapboxNavigationProvider
    private let navigationMapView: NavigationMapView
    private let navigationCore: NavigationCoreNative

    override init(frame: CGRect) {
        self.navigationProvider = MapboxNavigationProvider(coreConfig: .init())

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

        self.navigationCore = NavigationCoreNative()
        super.init(frame: frame)

        setupMap()
    }

    required init?(coder: NSCoder) {
        self.navigationProvider = MapboxNavigationProvider(coreConfig: .init())

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

        self.navigationCore = NavigationCoreNative()
        super.init(coder: coder)

        setupMap()
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
}
