import Foundation
import MapKit
import CoreLocation

struct NavigationProgress {
    let instruction: String
    let remainingDistanceMeters: Double
    let remainingEtaSeconds: Double
    let stepIndex: Int
}

final class NavigationManager {
    private(set) var currentRoute: MKRoute?
    private(set) var currentStepIndex: Int = 0

    private var navigableSteps: [MKRoute.Step] = []

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
            self?.navigableSteps = route.steps.filter { !$0.instructions.isEmpty }
            self?.currentStepIndex = 0

            completion(.success(route))
        }
    }

    func updateProgress(userLocation: CLLocation) -> NavigationProgress? {
        guard !navigableSteps.isEmpty else { return nil }

        advanceStepIfNeeded(userLocation: userLocation)

        let safeIndex = min(currentStepIndex, navigableSteps.count - 1)
        let currentStep = navigableSteps[safeIndex]

        let remainingDistance = remainingDistanceMeters(from: safeIndex, userLocation: userLocation)
        let remainingEta = remainingEtaSeconds()

        return NavigationProgress(
            instruction: currentStep.instructions,
            remainingDistanceMeters: remainingDistance,
            remainingEtaSeconds: remainingEta,
            stepIndex: safeIndex
        )
    }

    private func advanceStepIfNeeded(userLocation: CLLocation) {
        guard currentStepIndex < navigableSteps.count else { return }

        let currentStep = navigableSteps[currentStepIndex]
        guard let endCoordinate = lastCoordinate(of: currentStep.polyline) else { return }

        let endLocation = CLLocation(
            latitude: endCoordinate.latitude,
            longitude: endCoordinate.longitude
        )

        let distanceToStepEnd = userLocation.distance(from: endLocation)

        if distanceToStepEnd <= 35, currentStepIndex < navigableSteps.count - 1 {
            currentStepIndex += 1
        }
    }

    private func remainingDistanceMeters(from stepIndex: Int, userLocation: CLLocation) -> Double {
        guard stepIndex < navigableSteps.count else { return 0 }

        var total = 0.0

        let currentStep = navigableSteps[stepIndex]
        if let endCoordinate = lastCoordinate(of: currentStep.polyline) {
            let endLocation = CLLocation(
                latitude: endCoordinate.latitude,
                longitude: endCoordinate.longitude
            )
            total += userLocation.distance(from: endLocation)
        }

        if stepIndex + 1 < navigableSteps.count {
            for index in (stepIndex + 1)..<navigableSteps.count {
                total += navigableSteps[index].distance
            }
        }

        return total
    }

    private func remainingEtaSeconds() -> Double {
        guard let route = currentRoute, !navigableSteps.isEmpty else { return 0 }

        let remainingDistance = navigableSteps[currentStepIndex...]
            .reduce(0.0) { $0 + $1.distance }

        guard route.distance > 0 else { return 0 }

        let ratio = remainingDistance / route.distance
        return route.expectedTravelTime * ratio
    }

    private func lastCoordinate(of polyline: MKPolyline) -> CLLocationCoordinate2D? {
        guard polyline.pointCount > 0 else { return nil }

        var coordinates = Array(
            repeating: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            count: polyline.pointCount
        )

        polyline.getCoordinates(
            &coordinates,
            range: NSRange(location: 0, length: polyline.pointCount)
        )

        return coordinates.last
    }
}
