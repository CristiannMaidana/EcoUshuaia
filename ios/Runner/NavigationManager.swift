import Foundation
import MapKit
import CoreLocation

struct NavigationProgress {
    let instruction: String
    let remainingDistanceMeters: Double
    let remainingEtaSeconds: Double
    let stepIndex: Int
    let isOffRoute: Bool
}

final class NavigationManager {
    private(set) var currentRoute: MKRoute?
    private(set) var currentStepIndex: Int = 0
    private(set) var lastOriginCoordinate: CLLocationCoordinate2D?

    private var navigableSteps: [MKRoute.Step] = []

    private let offRouteThresholdMeters: Double = 45
    private let stepMatchThresholdMeters: Double = 35

    func calculateRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (Result<MKRoute, Error>) -> Void
    ) {
        lastOriginCoordinate = origin

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
        guard let route = currentRoute, !navigableSteps.isEmpty else { return nil }

        let isOffRoute = distanceFromRoute(userLocation, route: route) > offRouteThresholdMeters

        if !isOffRoute {
            updateCurrentStep(userLocation: userLocation)
        }

        let safeIndex = min(currentStepIndex, max(navigableSteps.count - 1, 0))
        let currentInstruction = navigableSteps[safeIndex].instructions

        let remainingDistance = isOffRoute
            ? route.distance
            : remainingDistanceMeters(from: safeIndex, userLocation: userLocation)

        let remainingEta = isOffRoute
            ? route.expectedTravelTime
            : remainingEtaSeconds(remainingDistance: remainingDistance)

        return NavigationProgress(
            instruction: currentInstruction,
            remainingDistanceMeters: remainingDistance,
            remainingEtaSeconds: remainingEta,
            stepIndex: safeIndex,
            isOffRoute: isOffRoute
        )
    }

    private func updateCurrentStep(userLocation: CLLocation) {
        guard !navigableSteps.isEmpty else { return }

        let startIndex = min(currentStepIndex, navigableSteps.count - 1)
        var bestIndex = startIndex
        var bestDistance = Double.greatestFiniteMagnitude

        for index in startIndex..<navigableSteps.count {
            let step = navigableSteps[index]
            let distance = distanceFromPolyline(userLocation, polyline: step.polyline)

            if distance < bestDistance {
                bestDistance = distance
                bestIndex = index
            }

            if distance <= stepMatchThresholdMeters {
                bestIndex = index
                break
            }
        }

        currentStepIndex = bestIndex
    }

    private func remainingDistanceMeters(from stepIndex: Int, userLocation: CLLocation) -> Double {
        guard stepIndex < navigableSteps.count else { return 0 }

        var total = 0.0

        let currentStep = navigableSteps[stepIndex]
        total += distanceFromPolyline(userLocation, polyline: currentStep.polyline)

        if stepIndex + 1 < navigableSteps.count {
            for index in (stepIndex + 1)..<navigableSteps.count {
                total += navigableSteps[index].distance
            }
        }

        return total
    }

    private func remainingEtaSeconds(remainingDistance: Double) -> Double {
        guard let route = currentRoute, route.distance > 0 else { return 0 }
        let ratio = max(0, min(1, remainingDistance / route.distance))
        return route.expectedTravelTime * ratio
    }

    private func distanceFromRoute(_ location: CLLocation, route: MKRoute) -> Double {
        distanceFromPolyline(location, polyline: route.polyline)
    }

    private func distanceFromPolyline(_ location: CLLocation, polyline: MKPolyline) -> Double {
        guard polyline.pointCount > 1 else { return .greatestFiniteMagnitude }

        let userPoint = MKMapPoint(location.coordinate)

        let pointsPointer = polyline.points()
        let points = Array(UnsafeBufferPointer(start: pointsPointer, count: polyline.pointCount))

        var minDistance = Double.greatestFiniteMagnitude

        for i in 0..<(points.count - 1) {
            let a = points[i]
            let b = points[i + 1]
            let distance = distanceFromPointToSegment(userPoint, a, b)
            if distance < minDistance {
                minDistance = distance
            }
        }

        return minDistance
    }

    private func distanceFromPointToSegment(
        _ p: MKMapPoint,
        _ a: MKMapPoint,
        _ b: MKMapPoint
    ) -> Double {
        let dx = b.x - a.x
        let dy = b.y - a.y

        if dx == 0 && dy == 0 {
            return p.distance(to: a)
        }

        let t = max(0, min(1, ((p.x - a.x) * dx + (p.y - a.y) * dy) / (dx * dx + dy * dy)))
        let projection = MKMapPoint(x: a.x + t * dx, y: a.y + t * dy)
        return p.distance(to: projection)
    }
}
