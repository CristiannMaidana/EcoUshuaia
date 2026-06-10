import CoreLocation
import Flutter
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

struct ContainerPinPayload {
    let idContenedor: Int
    let title: String?
    let description: String?
    let coordinate: CLLocationCoordinate2D

    init?(dictionary: [String: Any]) {
        guard let idContenedor = Self.intValue(dictionary["idContenedor"]),
              let latitude = Self.doubleValue(dictionary["latitude"]),
              let longitude = Self.doubleValue(dictionary["longitude"]) else {
            return nil
        }

        self.idContenedor = idContenedor
        self.title = dictionary["title"] as? String
        self.description = dictionary["description"] as? String
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    private static func intValue(_ value: Any?) -> Int? {
        if let int = value as? Int {
            return int
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        return nil
    }

    private static func doubleValue(_ value: Any?) -> Double? {
        if let double = value as? Double {
            return double
        }
        if let int = value as? Int {
            return Double(int)
        }
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        return nil
    }
}

@MainActor
final class ContainerPinsCoordinator {
    static let annotationManagerId = "container-pins-manager"
    private static let annotationImageName = "container-pin-marker"
    private static let fullSizeZoomThreshold: Double = 13.2
    private static let hiddenZoomThreshold: Double = 12.0

    private weak var navigationMapView: NavigationMapView?
    private var pointAnnotationManager: PointAnnotationManager?
    private var styleLoadedCancelable: AnyCancelable?
    private var cameraChangedCancelable: AnyCancelable?
    private var currentContainers: [ContainerPinPayload] = []
    private var isStyleLoaded = false
    private var lastAppliedIconSize: Double?
    private var lastAppliedIconOpacity: Double?

    var onContainerSelected: ((Int) -> Void)?

    init(navigationMapView: NavigationMapView) {
        self.navigationMapView = navigationMapView
        observeStyleLoaded()
        observeCameraChanged()
    }

    func setContainers(_ containers: [ContainerPinPayload]) {
        currentContainers = containers
        renderContainersIfPossible()
    }

    func clearContainers() {
        currentContainers = []
        pointAnnotationManager?.annotations = []
    }

    private func observeStyleLoaded() {
        guard let navigationMapView else { return }

        styleLoadedCancelable = navigationMapView.mapView.mapboxMap.onStyleLoaded.observe { [weak self] _ in
            guard let self else { return }
            self.isStyleLoaded = true
            self.renderContainersIfPossible()
            self.updateContainerAppearanceForCurrentZoom(force: true)
        }
    }

    private func observeCameraChanged() {
        guard let navigationMapView else { return }

        cameraChangedCancelable = navigationMapView.mapView.mapboxMap.onCameraChanged.observe { [weak self] _ in
            self?.updateContainerAppearanceForCurrentZoom()
        }
    }

    private func renderContainersIfPossible() {
        guard isStyleLoaded else { return }

        let annotations = currentContainers.map(makeAnnotation(from:))
        let manager = annotationManager()
        manager.annotations = annotations
        updateContainerAppearanceForCurrentZoom(force: true)
    }

    private func annotationManager() -> PointAnnotationManager {
        if let pointAnnotationManager {
            return pointAnnotationManager
        }

        guard let navigationMapView else {
            preconditionFailure("NavigationMapView must exist before adding container pins.")
        }

        let manager = navigationMapView.mapView.annotations.makePointAnnotationManager(
            id: Self.annotationManagerId
        )
        manager.iconAllowOverlap = true
        manager.iconIgnorePlacement = true
        manager.iconAnchor = .bottom

        pointAnnotationManager = manager
        return manager
    }

    private func updateContainerAppearanceForCurrentZoom(force: Bool = false) {
        guard isStyleLoaded,
              let navigationMapView else {
            return
        }

        let zoom = navigationMapView.mapView.mapboxMap.cameraState.zoom
        let iconSize = containerIconSize(for: zoom)
        let iconOpacity = containerIconOpacity(for: zoom)

        guard force ||
                lastAppliedIconSize != iconSize ||
                lastAppliedIconOpacity != iconOpacity else {
            return
        }

        let manager = annotationManager()
        manager.iconSize = iconSize
        manager.iconOpacity = iconOpacity

        lastAppliedIconSize = iconSize
        lastAppliedIconOpacity = iconOpacity
    }

    private func containerIconSize(for zoom: Double) -> Double {
        if zoom <= Self.hiddenZoomThreshold {
            return 0.0
        }
        if zoom >= Self.fullSizeZoomThreshold {
            return 1.0
        }

        let progress = (zoom - Self.hiddenZoomThreshold) / (Self.fullSizeZoomThreshold - Self.hiddenZoomThreshold)
        return max(0.0, min(1.0, progress))
    }

    private func containerIconOpacity(for zoom: Double) -> Double {
        if zoom <= Self.hiddenZoomThreshold {
            return 0.0
        }
        if zoom >= Self.fullSizeZoomThreshold {
            return 1.0
        }

        let progress = (zoom - Self.hiddenZoomThreshold) / (Self.fullSizeZoomThreshold - Self.hiddenZoomThreshold)
        return max(0.0, min(1.0, progress))
    }

    private func makeAnnotation(from container: ContainerPinPayload) -> PointAnnotation {
        var annotation = PointAnnotation(
            id: "container-\(container.idContenedor)",
            coordinate: container.coordinate
        )

        annotation.image = .init(
            image: containerPinImage(),
            name: Self.annotationImageName
        )
        annotation.iconAnchor = .bottom
        annotation.iconOffset = [0, -2]
        annotation.iconSize = 1.0
        annotation.tapHandler = { [weak self] _ in
            self?.onContainerSelected?(container.idContenedor)
            return true
        }
        return annotation
    }

    private func containerPinImage() -> UIImage {
        if let assetImage = loadContainerAssetImage() {
            return resizedImage(assetImage, to: CGSize(width: 34, height: 34))
        }

        return fallbackContainerPinImage()
    }

    private func loadContainerAssetImage() -> UIImage? {
        let assetKey = FlutterDartProject.lookupKey(forAsset: "assets/icons/mapa/container.png")
        let assetPathCandidates = [
            Bundle.main.path(forResource: assetKey, ofType: nil),
            Bundle.main.resourceURL?.appendingPathComponent(assetKey).path,
            Bundle.main.resourceURL?.appendingPathComponent("Frameworks/App.framework/\(assetKey)").path
        ]

        for path in assetPathCandidates {
            guard let path else { continue }
            if let image = UIImage(contentsOfFile: path) {
                return image
            }
        }

        return nil
    }

    private func resizedImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    private func fallbackContainerPinImage() -> UIImage {
        let size = CGSize(width: 30, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let cgContext = context.cgContext
            let pinColor = UIColor(red: 0.12, green: 0.62, blue: 0.31, alpha: 1)
            let strokeColor = UIColor.white

            let circleRect = CGRect(x: 3, y: 3, width: 24, height: 24)
            let tipPoint = CGPoint(x: size.width / 2, y: size.height - 3)

            let path = UIBezierPath()
            path.append(UIBezierPath(ovalIn: circleRect))
            path.move(to: CGPoint(x: circleRect.midX - 5, y: circleRect.maxY - 1))
            path.addLine(to: tipPoint)
            path.addLine(to: CGPoint(x: circleRect.midX + 5, y: circleRect.maxY - 1))
            path.close()

            pinColor.setFill()
            path.fill()

            strokeColor.setStroke()
            path.lineWidth = 2
            path.stroke()

            let innerCircleRect = CGRect(x: 9, y: 9, width: 12, height: 12)
            cgContext.setFillColor(strokeColor.cgColor)
            cgContext.fillEllipse(in: innerCircleRect)
        }
    }
}
