import UIKit
import MapKit
import CoreLocation
import Flutter

final class NavigationMapView: UIView, MKMapViewDelegate {
    private let mapView = MKMapView()
    private let locationService = LocationService()
    private let navigationManager = NavigationManager()

    private var hasCalculatedInitialRoute = false
    private let destinationCoordinate: CLLocationCoordinate2D
    private let destinationTitle: String?
    private let onRouteInfoChanged: (([String: Any]) -> Void)?

    init(
        frame: CGRect,
        destinationCoordinate: CLLocationCoordinate2D,
        destinationTitle: String?,
        onRouteInfoChanged: (([String: Any]) -> Void)?
    ) {
        self.destinationCoordinate = destinationCoordinate
        self.destinationTitle = destinationTitle
        self.onRouteInfoChanged = onRouteInfoChanged
        super.init(frame: frame)
        setupMap()
        setupServices()
        showDestinationPin()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupServices() {
        locationService.delegate = self
        locationService.requestPermissionAndStartIfNeeded()
    }

    private func showDestinationPin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationCoordinate
        annotation.title = destinationTitle
        mapView.addAnnotation(annotation)
    }

    private func drawRoute(_ route: MKRoute) {
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(route.polyline)

        let rect = route.polyline.boundingMapRect
        mapView.setVisibleMapRect(
            rect,
            edgePadding: UIEdgeInsets(top: 120, left: 50, bottom: 120, right: 50),
            animated: true
        )
    }

    private func emitProgress(_ progress: NavigationProgress) {
        onRouteInfoChanged?([
            "instruction": progress.instruction,
            "distanceMeters": progress.remainingDistanceMeters,
            "etaSeconds": progress.remainingEtaSeconds,
            "stepIndex": progress.stepIndex,
        ])
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 6
        return renderer
    }
}

extension NavigationMapView: LocationServiceDelegate {
    func locationServiceDidChangeAuthorization(_ status: CLAuthorizationStatus) {}

    func locationServiceDidUpdateLocation(_ location: CLLocation) {
        if !hasCalculatedInitialRoute {
            hasCalculatedInitialRoute = true

            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1200,
                longitudinalMeters: 1200
            )
            mapView.setRegion(region, animated: true)

            navigationManager.calculateRoute(
                from: location.coordinate,
                to: destinationCoordinate
            ) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let route):
                    self.drawRoute(route)

                    if let progress = self.navigationManager.updateProgress(userLocation: location) {
                        self.emitProgress(progress)
                    }

                case .failure(let error):
                    print("Route error: \(error.localizedDescription)")
                }
            }

            return
        }

        if let progress = navigationManager.updateProgress(userLocation: location) {
            emitProgress(progress)
        }
    }

    func locationServiceDidFail(_ error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
