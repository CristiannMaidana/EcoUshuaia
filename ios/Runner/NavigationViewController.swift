import UIKit
import MapKit
import CoreLocation

final class NavigationViewController: UIViewController, MKMapViewDelegate {
    private let mapView = MKMapView()
    private let locationService = LocationService()
    private let navigationManager = NavigationManager()

    private var hasCenteredOnUser = false

    private let destinationCoordinate = CLLocationCoordinate2D(
        latitude: -54.8070,
        longitude: -68.3047
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        }

        setupMap()
        setupCloseButton()
        setupServices()
        showDestinationPin()
    }

    private func setupServices() {
        locationService.delegate = self
        locationService.requestPermissionAndStartIfNeeded()
    }

    private func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cerrar", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func showDestinationPin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationCoordinate
        annotation.title = "Destino"
        mapView.addAnnotation(annotation)
    }

    private func drawRoute(_ route: MKRoute) {
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(route.polyline)

        let rect = route.polyline.boundingMapRect
        mapView.setVisibleMapRect(
            rect,
            edgePadding: UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50),
            animated: true
        )

        print("Distancia total: \(route.distance) metros")
        print("Tiempo estimado: \(route.expectedTravelTime) segundos")

        for (index, step) in route.steps.enumerated() {
            if !step.instructions.isEmpty {
                print("Step \(index): \(step.instructions)")
            }
        }
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

    @objc
    private func closeTapped() {
        dismiss(animated: true)
    }
}

extension NavigationViewController: LocationServiceDelegate {
    func locationServiceDidChangeAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            break

        case .denied, .restricted, .notDetermined:
            break

        @unknown default:
            break
        }
    }

    func locationServiceDidUpdateLocation(_ location: CLLocation) {
        if !hasCenteredOnUser {
            hasCenteredOnUser = true

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

                case .failure(let error):
                    print("Route error: \(error.localizedDescription)")
                }
            }
        }
    }

    func locationServiceDidFail(_ error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
