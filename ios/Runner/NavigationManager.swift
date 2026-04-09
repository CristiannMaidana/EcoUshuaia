import Foundation
import MapKit
import CoreLocation

final class NavigationManager {
    private(set) var currentRoute: MKRoute?

    func calculateRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (Result<MKRoute, Error>) -> Void
    ) {
        let sourcePlacemark = MKPlacemark(coordinate: origin)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [weak self] response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let route = response?.routes.first else {
                completion(.failure(NSError(
                    domain: "NavigationManager",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "No se encontró una ruta"]
                )))
                return
            }

            self?.currentRoute = route
            completion(.success(route))
        }
    }
}
