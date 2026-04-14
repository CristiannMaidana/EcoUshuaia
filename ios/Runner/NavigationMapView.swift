import UIKit
import Combine
import CoreLocation
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit

final class NativeMapView: UIView {

    private let navigationProvider: MapboxNavigationProvider
    private let navigationMapView: NavigationMapView
    private let navigationCore: NavigationCoreNative
    private let initialCoordinate: CLLocationCoordinate2D
    private let initialZoom: Double

    init(
        frame: CGRect,
        latitude: Double = -54.8070,
        longitude: Double = -68.3047,
        zoom: Double = 13
    ) {
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
        self.initialCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.initialZoom = zoom
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
        self.initialCoordinate = CLLocationCoordinate2D(latitude: -54.8070, longitude: -68.3047)
        self.initialZoom = 13
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

        navigationMapView.mapView.mapboxMap.setCamera(
            to: CameraOptions(center: initialCoordinate, zoom: initialZoom)
        )
    }
}
