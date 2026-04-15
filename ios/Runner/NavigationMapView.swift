import Combine
import CoreLocation
import Flutter
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

final class NativeMapView: UIView, FlutterPlatformView {
    private let runtime: NativeMapRuntime
    private let navigationMapView: NavigationMapView
    private let initialCoordinate: CLLocationCoordinate2D
    private let initialZoom: Double

    init(
        frame: CGRect,
        runtime: NativeMapRuntime,
        latitude: Double = -54.8070,
        longitude: Double = -68.3047,
        zoom: Double = 13
    ) {
        self.runtime = runtime
        self.initialCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.initialZoom = zoom

        let navigation = runtime.navigationProvider.navigation()

        self.navigationMapView = NavigationMapView(
            location: navigation.locationMatching
                .map(\.mapMatchingResult.enhancedLocation)
                .eraseToAnyPublisher(),
            routeProgress: navigation.routeProgress
                .map(\.?.routeProgress)
                .eraseToAnyPublisher(),
            heading: navigation.heading,
            predictiveCacheManager: runtime.navigationProvider.predictiveCacheManager
        )

        super.init(frame: frame)

        setupMap()
    }

    required init?(coder: NSCoder) {
        self.runtime = NativeMapRuntime.shared
        self.initialCoordinate = CLLocationCoordinate2D(latitude: -54.8070, longitude: -68.3047)
        self.initialZoom = 13

        let navigation = runtime.navigationProvider.navigation()

        self.navigationMapView = NavigationMapView(
            location: navigation.locationMatching
                .map(\.mapMatchingResult.enhancedLocation)
                .eraseToAnyPublisher(),
            routeProgress: navigation.routeProgress
                .map(\.?.routeProgress)
                .eraseToAnyPublisher(),
            heading: navigation.heading,
            predictiveCacheManager: runtime.navigationProvider.predictiveCacheManager
        )

        super.init(coder: coder)

        setupMap()
    }

    func view() -> UIView {
        self
    }

    func showRoute(_ navigationRoutes: NavigationRoutes) {
        navigationMapView.showcase(navigationRoutes, animated: true)
    }

    func followActiveNavigation() {
        centerTurnByTurnCamera()
    }

    func centerTurnByTurnCamera() {
        navigationMapView.navigationCamera.viewportPadding = UIEdgeInsets(
            top: 100,
            left: 16,
            bottom: 260,
            right: 16
        )
        navigationMapView.navigationCamera.update(cameraState: .following)
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
