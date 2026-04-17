import Combine
import CoreLocation
import Flutter
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

final class NativeMapView: UIView, FlutterPlatformView {
    private static let destinationPreviewAnnotationManagerId = "destination-preview-manager"
    private static let destinationPreviewImageName = "destination-preview-pin"

    private let runtime: NativeMapRuntime
    private let navigationMapView: NavigationMapView
    let containerPinsCoordinator: ContainerPinsCoordinator
    private let initialCoordinate: CLLocationCoordinate2D
    private let initialZoom: Double
    private var cancellables = Set<AnyCancellable>()
    private var keepsTurnByTurnCameraCentered = false
    private var isUsingNavigationPuck: Bool?
    private var isPreviewOverviewModeActive = false
    private var previewSheetBottomInset: CGFloat = 0
    private var previewSheetState: PreviewSheetState = .collapsed
    private var lastPreviewOverviewCameraKey: PreviewOverviewCameraKey?
    private var destinationPreviewManager: PointAnnotationManager?
    private var destinationPreviewCoordinate: CLLocationCoordinate2D?
    private var hiddenAnnotationLayerVisibilityById: [String: String] = [:]

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
        let routeProgress = navigation.routeProgress
            .map(\.?.routeProgress)
            .eraseToAnyPublisher()
        let location = navigation.locationMatching
            .combineLatest(routeProgress)
            .map { state, routeProgress in
                routeProgress == nil ? state.location : state.enhancedLocation
            }
            .eraseToAnyPublisher()

        self.navigationMapView = NavigationMapView(
            location: location,
            routeProgress: routeProgress,
            heading: navigation.heading,
            predictiveCacheManager: runtime.navigationProvider.predictiveCacheManager
        )
        self.containerPinsCoordinator = ContainerPinsCoordinator(
            navigationMapView: navigationMapView
        )

        super.init(frame: frame)

        setupMap()
        bindTurnByTurnCameraLock()
    }

    required init?(coder: NSCoder) {
        self.runtime = NativeMapRuntime.shared
        self.initialCoordinate = CLLocationCoordinate2D(latitude: -54.8070, longitude: -68.3047)
        self.initialZoom = 13

        let navigation = runtime.navigationProvider.navigation()
        let routeProgress = navigation.routeProgress
            .map(\.?.routeProgress)
            .eraseToAnyPublisher()
        let location = navigation.locationMatching
            .combineLatest(routeProgress)
            .map { state, routeProgress in
                routeProgress == nil ? state.location : state.enhancedLocation
            }
            .eraseToAnyPublisher()

        self.navigationMapView = NavigationMapView(
            location: location,
            routeProgress: routeProgress,
            heading: navigation.heading,
            predictiveCacheManager: runtime.navigationProvider.predictiveCacheManager
        )
        self.containerPinsCoordinator = ContainerPinsCoordinator(
            navigationMapView: navigationMapView
        )

        super.init(coder: coder)

        setupMap()
        bindTurnByTurnCameraLock()
    }

    func view() -> UIView {
        self
    }

    func showRoute(_ navigationRoutes: NavigationRoutes) {
        navigationMapView.show(
            navigationRoutes,
            routeAnnotationKinds: [.relativeDurationsOnAlternative]
        )
    }

    func showDestinationPreview(at coordinate: CLLocationCoordinate2D) {
        guard isValidCoordinate(coordinate) else {
            return
        }
        guard navigationMapView.bounds.width > 0, navigationMapView.bounds.height > 0 else {
            return
        }

        if let destinationPreviewCoordinate,
           destinationPreviewCoordinate.isSameCoordinate(as: coordinate) {
            focusDestinationCamera(coordinate)
            return
        }

        destinationPreviewCoordinate = coordinate
        destinationPreviewAnnotationManager().annotations = [
            makeDestinationPreviewAnnotation(at: coordinate)
        ]
        setNonContainerAnnotationsHidden(true)
        focusDestinationCamera(coordinate)
    }

    func focusDestinationCamera(_ coordinate: CLLocationCoordinate2D) {
        let padding = UIEdgeInsets(
            top: 96,
            left: 24,
            bottom: previewSheetBottomInset + 32,
            right: 24
        )
        let initialCameraOptions = CameraOptions(
            padding: padding,
            bearing: 0,
            pitch: 0
        )

        do {
            let cameraOptions = try navigationMapView.mapView.mapboxMap.camera(
                for: [coordinate],
                camera: initialCameraOptions,
                coordinatesPadding: nil,
                maxZoom: 15,
                offset: nil
            )
            navigationMapView.navigationCamera.stop()
            navigationMapView.navigationCamera.viewportPadding = padding
            navigationMapView.mapView.camera.ease(to: cameraOptions, duration: 0.35)
        } catch {
            return
        }
    }

    func setNonContainerAnnotationsHidden(_ hidden: Bool) {
        let annotationManagers = navigationMapView.mapView.annotations.annotationManagersById
        let visibleValue = Visibility.visible.rawValue
        let hiddenValue = Visibility.none.rawValue

        for manager in annotationManagers.values {
            guard manager.id != ContainerPinsCoordinator.annotationManagerId,
                  manager.id != Self.destinationPreviewAnnotationManagerId else {
                continue
            }

            if hidden {
                if hiddenAnnotationLayerVisibilityById[manager.layerId] == nil {
                    let visibility = navigationMapView.mapView.mapboxMap
                        .layerProperty(for: manager.layerId, property: "visibility")
                        .value as? String
                    hiddenAnnotationLayerVisibilityById[manager.layerId] = visibility ?? visibleValue
                }
                try? navigationMapView.mapView.mapboxMap.setLayerProperty(
                    for: manager.layerId,
                    property: "visibility",
                    value: hiddenValue
                )
            } else {
                let visibility = hiddenAnnotationLayerVisibilityById[manager.layerId] ?? visibleValue
                try? navigationMapView.mapView.mapboxMap.setLayerProperty(
                    for: manager.layerId,
                    property: "visibility",
                    value: visibility
                )
            }
        }

        if !hidden {
            hiddenAnnotationLayerVisibilityById.removeAll()
        }
    }

    func clearDestinationPreview() {
        guard destinationPreviewCoordinate != nil else {
            return
        }

        destinationPreviewCoordinate = nil
        destinationPreviewManager?.annotations = []
        setNonContainerAnnotationsHidden(false)
    }

    func followActiveNavigation() {
        stopPreviewOverviewMode()
        keepsTurnByTurnCameraCentered = true
        centerTurnByTurnCamera()
    }

    func startPreviewOverviewMode() {
        isPreviewOverviewModeActive = true
        lastPreviewOverviewCameraKey = nil
        updatePreviewRouteOverviewIfNeeded(force: true)
    }

    func updatePreviewSheetInset(_ height: CGFloat, state: String) {
        previewSheetBottomInset = max(0, height)
        previewSheetState = PreviewSheetState(rawValue: state) ?? .moving
        if let destinationPreviewCoordinate {
            focusDestinationCamera(destinationPreviewCoordinate)
        }
        updatePreviewRouteOverviewIfNeeded()
    }

    func updatePreviewRouteOverviewIfNeeded(force: Bool = false) {
        guard isPreviewOverviewModeActive else {
            return
        }
        guard !keepsTurnByTurnCameraCentered else {
            return
        }
        guard force || previewSheetState.allowsOverviewUpdates else {
            return
        }
        guard navigationMapView.bounds.width > 0, navigationMapView.bounds.height > 0 else {
            return
        }
        guard let previewRoute = currentPreviewRouteCoordinates() else {
            return
        }

        let bottomInset = Int(previewSheetBottomInset.rounded())
        let cameraKey = PreviewOverviewCameraKey(
            routeId: previewRoute.routeId,
            bottomInset: bottomInset,
            sheetState: previewSheetState
        )

        guard force || cameraKey != lastPreviewOverviewCameraKey else {
            return
        }

        applyPreviewOverviewCamera(
            coordinates: previewRoute.coordinates,
            bottomInset: CGFloat(bottomInset)
        )
        lastPreviewOverviewCameraKey = cameraKey
    }

    func applyPreviewOverviewCamera(coordinates: [CLLocationCoordinate2D], bottomInset: CGFloat) {
        let padding = UIEdgeInsets(
            top: 96,
            left: 24,
            bottom: bottomInset + 32,
            right: 24
        )
        let initialCameraOptions = CameraOptions(
            padding: padding,
            bearing: 0,
            pitch: 0
        )

        do {
            navigationMapView.navigationCamera.stop()
            navigationMapView.navigationCamera.viewportPadding = padding
            let cameraOptions = try navigationMapView.mapView.mapboxMap.camera(
                for: coordinates,
                camera: initialCameraOptions,
                coordinatesPadding: nil,
                maxZoom: nil,
                offset: nil
            )
            navigationMapView.mapView.camera.ease(to: cameraOptions, duration: 0.35)
        } catch {
            return
        }
    }

    func stopPreviewOverviewMode() {
        isPreviewOverviewModeActive = false
        lastPreviewOverviewCameraKey = nil
    }

    func setMapStyle(_ styleIdentifier: String) {
        navigationMapView.mapView.mapboxMap.mapStyle = mapStyle(for: styleIdentifier)
    }

    func centerTurnByTurnCamera() {
        configureTurnByTurnCamera()
        navigationMapView.navigationCamera.viewportPadding = UIEdgeInsets(
            top: 200,
            left: 16,
            bottom: 60,
            right: 16
        )
        navigationMapView.navigationCamera.update(cameraState: .following)
    }

    func releaseTurnByTurnCameraLock() {
        keepsTurnByTurnCameraCentered = false
        navigationMapView.navigationCamera.viewportPadding = .zero

        if let viewportDataSource = navigationMapView.navigationCamera.viewportDataSource as? MobileViewportDataSource {
            viewportDataSource.options.followingCameraOptions = FollowingCameraOptions()
        }

        try? navigationMapView.mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions())
    }

    func resetAfterNavigationCancel() {
        clearDestinationPreview()
        stopPreviewOverviewMode()
        releaseTurnByTurnCameraLock()
        navigationMapView.removeRoutes()
        navigationMapView.navigationCamera.update(cameraState: .idle)
        navigationMapView.mapView.mapboxMap.setCamera(
            to: CameraOptions(center: initialCoordinate, zoom: initialZoom)
        )
    }

    private func bindTurnByTurnCameraLock() {
        runtime.navigationProvider.navigation().routeProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeProgressState in
                guard let self else {
                    return
                }

                let isNavigating = routeProgressState?.routeProgress != nil
                self.configureUserLocationPuck(isNavigating: isNavigating)

                guard self.keepsTurnByTurnCameraCentered, isNavigating else {
                    return
                }

                self.centerTurnByTurnCamera()
            }
            .store(in: &cancellables)
    }

    private func configureTurnByTurnCamera() {
        guard let viewportDataSource = navigationMapView.navigationCamera.viewportDataSource as? MobileViewportDataSource else {
            return
        }

        viewportDataSource.options.followingCameraOptions.centerUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.bearingUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.pitchUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.paddingUpdatesAllowed = false
        viewportDataSource.options.followingCameraOptions.followsLocationCourse = true
        viewportDataSource.options.followingCameraOptions.zoomRange = 13.75...16.35

        let padding = UIEdgeInsets(
            top: 200,
            left: 16,
            bottom: 60,
            right: 16
        )
        viewportDataSource.currentNavigationCameraOptions.followingCamera.padding = padding
        try? navigationMapView.mapView.mapboxMap.setCameraBounds(
            with: CameraBoundsOptions(minZoom: 13.75)
        )
    }

    private func currentPreviewRouteCoordinates() -> (routeId: String, coordinates: [CLLocationCoordinate2D])? {
        guard let navigationRoutes = runtime.navigationCore.currentNavigationRoutes else {
            return nil
        }

        let routes = [navigationRoutes.mainRoute.route] + navigationRoutes.alternativeRoutes.map(\.route)
        let coordinates = routes.flatMap { route in
            route.shape?.coordinates ?? []
        }

        guard !coordinates.isEmpty else {
            return nil
        }

        let routeIds = [navigationRoutes.mainRoute.routeId] + navigationRoutes.alternativeRoutes.map(\.routeId)
        return (
            routeId: routeIds.map { String(describing: $0) }.joined(separator: "|"),
            coordinates: coordinates
        )
    }

    private func destinationPreviewAnnotationManager() -> PointAnnotationManager {
        if let destinationPreviewManager {
            return destinationPreviewManager
        }

        let manager = navigationMapView.mapView.annotations.makePointAnnotationManager(
            id: Self.destinationPreviewAnnotationManagerId
        )
        manager.iconAllowOverlap = true
        manager.iconIgnorePlacement = true
        manager.iconAnchor = .bottom
        destinationPreviewManager = manager
        return manager
    }

    private func makeDestinationPreviewAnnotation(at coordinate: CLLocationCoordinate2D) -> PointAnnotation {
        var annotation = PointAnnotation(
            id: "destination-preview",
            coordinate: coordinate
        )
        annotation.image = .init(
            image: destinationPreviewPinImage(),
            name: Self.destinationPreviewImageName
        )
        annotation.iconAnchor = .bottom
        annotation.iconOffset = [0, -2]
        annotation.iconSize = 1.0
        return annotation
    }

    private func destinationPreviewPinImage() -> UIImage {
        let size = CGSize(width: 30, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let cgContext = context.cgContext
            let pinColor = UIColor(red: 0.90, green: 0.16, blue: 0.12, alpha: 1)
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

            cgContext.setFillColor(strokeColor.cgColor)
            cgContext.fillEllipse(in: CGRect(x: 10, y: 10, width: 10, height: 10))
        }
    }
    
    func resetCameraToIdle() {
        navigationMapView.navigationCamera.viewportPadding = .zero
        navigationMapView.navigationCamera.update(cameraState: .idle)

        let currentCenter = navigationMapView.mapView.mapboxMap.cameraState.center

        navigationMapView.mapView.camera.ease(
            to: CameraOptions(
                center: currentCenter,
                bearing: 0, pitch: 0
            ),
            duration: 0.35
        )
    }
    
    private func isValidCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        coordinate.latitude.isFinite &&
            coordinate.longitude.isFinite &&
            (-90...90).contains(coordinate.latitude) &&
            (-180...180).contains(coordinate.longitude)
    }

    private func setupMap() {
        runtime.navigationProvider.tripSession().startFreeDrive()
        navigationMapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigationMapView)

        NSLayoutConstraint.activate([
            navigationMapView.topAnchor.constraint(equalTo: topAnchor),
            navigationMapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationMapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationMapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        configureUserLocationPuck(isNavigating: false)
        navigationMapView.mapView.mapboxMap.setCamera(
            to: CameraOptions(center: initialCoordinate, zoom: initialZoom)
        )
    }

    private func configureUserLocationPuck(isNavigating: Bool) {
        guard isUsingNavigationPuck != isNavigating else {
            return
        }

        isUsingNavigationPuck = isNavigating
        navigationMapView.puckType = isNavigating
            ? .puck3D(.navigationDefault)
            : .puck2D(.makeDefault(showBearing: true))
        navigationMapView.puckBearing = .course
    }

    private func mapStyle(for styleIdentifier: String) -> MapboxMaps.MapStyle {
        switch styleIdentifier {
        case "standardSatellite":
            return .standardSatellite
        case "dark":
            return .dark
        case "outdoors":
            return .outdoors
        default:
            return .standard
        }
    }
}

private enum PreviewSheetState: String {
    case collapsed
    case primary
    case expanded
    case moving

    var allowsOverviewUpdates: Bool {
        self == .collapsed || self == .primary
    }
}

private struct PreviewOverviewCameraKey: Equatable {
    let routeId: String
    let bottomInset: Int
    let sheetState: PreviewSheetState
}

private extension CLLocationCoordinate2D {
    func isSameCoordinate(as other: CLLocationCoordinate2D) -> Bool {
        abs(latitude - other.latitude) < 0.000001 &&
            abs(longitude - other.longitude) < 0.000001
    }
}
