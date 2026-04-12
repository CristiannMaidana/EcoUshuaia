import MapboxMaps
import UIKit

@MainActor
final class NativeContainerAnnotationCoordinator {
    private let mapView: MapView
    private var containerManager: CircleAnnotationManager?
    private var destinationManager: CircleAnnotationManager?
    private let onContainerSelected: (Int) -> Void

    init(
        mapView: MapView,
        onContainerSelected: @escaping (Int) -> Void
    ) {
        self.mapView = mapView
        self.onContainerSelected = onContainerSelected
    }

    func setContainers(_ containers: [NativeContainerPayload]) {
        let manager = ensureContainerManager()
        manager.annotations = containers.map { container in
            var annotation = CircleAnnotation(
                id: "container_\(container.idContenedor)",
                centerCoordinate: container.coordinate
            )
            annotation.circleRadius = 7
            annotation.circleColor = StyleColor(.systemGreen)
            annotation.circleStrokeWidth = 2
            annotation.circleStrokeColor = StyleColor(.white)
            annotation.tapHandler = { [weak self] _ in
                self?.onContainerSelected(container.idContenedor)
                return true
            }
            return annotation
        }
    }

    func clearContainers() {
        containerManager?.annotations = []
    }

    func showDestination(_ waypoint: NativeWaypointPayload) {
        let manager = ensureDestinationManager()
        var annotation = CircleAnnotation(
            id: "destination",
            centerCoordinate: waypoint.coordinate
        )
        annotation.circleRadius = 9
        annotation.circleColor = StyleColor(.systemBlue)
        annotation.circleStrokeWidth = 3
        annotation.circleStrokeColor = StyleColor(.white)
        manager.annotations = [annotation]
    }

    func clearDestination() {
        destinationManager?.annotations = []
    }

    private func ensureContainerManager() -> CircleAnnotationManager {
        if let containerManager {
            return containerManager
        }

        let manager = mapView.annotations.makeCircleAnnotationManager(
            id: "eco_ushuaia_containers"
        )
        manager.circlePitchAlignment = .map
        manager.circlePitchScale = .map
        containerManager = manager
        return manager
    }

    private func ensureDestinationManager() -> CircleAnnotationManager {
        if let destinationManager {
            return destinationManager
        }

        let manager = mapView.annotations.makeCircleAnnotationManager(
            id: "eco_ushuaia_destination"
        )
        manager.circlePitchAlignment = .map
        manager.circlePitchScale = .map
        destinationManager = manager
        return manager
    }
}
