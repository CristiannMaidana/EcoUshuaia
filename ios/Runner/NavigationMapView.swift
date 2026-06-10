import Combine
import CoreLocation
import Flutter
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

struct ZonePolygonPayload {
    let idZona: Int
    let nombreZona: String?
    let colorZona: String?
    let geometry: MultiPolygon

    init?(dictionary: [String: Any]) {
        guard let idZona = Self.intValue(dictionary["idZona"] ?? dictionary["id_zona"]),
              let geometryDictionary = Self.geometryDictionary(from: dictionary),
              let geometry = Self.multiPolygon(from: geometryDictionary) else {
            return nil
        }

        self.idZona = idZona
        self.nombreZona = dictionary["nombreZona"] as? String ?? dictionary["nombre_zona"] as? String
        self.colorZona = dictionary["colorZona"] as? String ?? dictionary["color_zona"] as? String
        self.geometry = geometry
    }

    private static func geometryDictionary(from dictionary: [String: Any]) -> [String: Any]? {
        if let geometry = dictionary["coordenada"] as? [String: Any] {
            return geometry
        }
        if let geometry = dictionary["geometry"] as? [String: Any] {
            return geometry
        }
        if dictionary["type"] is String, dictionary["coordinates"] != nil {
            return dictionary
        }
        return nil
    }

    private static func multiPolygon(from dictionary: [String: Any]) -> MultiPolygon? {
        let type = (dictionary["type"] as? String ?? "MultiPolygon").lowercased()
        guard let rawCoordinates = dictionary["coordinates"] as? [Any] else {
            return nil
        }

        switch type {
        case "polygon":
            let polygon = parsePolygon(rawCoordinates)
            guard !polygon.isEmpty else {
                return nil
            }
            return MultiPolygon([polygon])
        default:
            let polygons = rawCoordinates.compactMap { value -> [[CLLocationCoordinate2D]]? in
                guard let rawPolygon = value as? [Any] else {
                    return nil
                }
                let polygon = parsePolygon(rawPolygon)
                return polygon.isEmpty ? nil : polygon
            }

            guard !polygons.isEmpty else {
                return nil
            }
            return MultiPolygon(polygons)
        }
    }

    private static func parsePolygon(_ rawPolygon: [Any]) -> [[CLLocationCoordinate2D]] {
        rawPolygon.compactMap { value -> [CLLocationCoordinate2D]? in
            guard let rawRing = value as? [Any] else {
                return nil
            }
            let ring = parseRing(rawRing)
            return ring.count >= 4 ? ring : nil
        }
    }

    private static func parseRing(_ rawRing: [Any]) -> [CLLocationCoordinate2D] {
        rawRing.compactMap { value -> CLLocationCoordinate2D? in
            guard let point = value as? [Any],
                  point.count >= 2,
                  let longitude = doubleValue(point[0]),
                  let latitude = doubleValue(point[1]) else {
                return nil
            }

            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return isValidCoordinate(coordinate) ? coordinate : nil
        }
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

    private static func isValidCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        coordinate.latitude.isFinite &&
            coordinate.longitude.isFinite &&
            (-90...90).contains(coordinate.latitude) &&
            (-180...180).contains(coordinate.longitude)
    }
}

final class NativeMapView: UIView, FlutterPlatformView {
    private static let destinationPreviewAnnotationManagerId = "destination-preview-manager"
    private static let destinationPreviewImageName = "destination-preview-pin"
    private static let zoneHintsSourceId = "zones-hints-source"
    private static let zoneHintsLayerId = "zones-hints-layer"
    private static let zoneVisibleSourceId = "zones-visible-source"
    private static let zoneVisibleFillLayerId = "zones-visible-fill-layer"
    private static let zoneVisibleStrokeLayerId = "zones-visible-stroke-layer"
    private static let zoneActiveSourceId = "zones-active-source"
    private static let zoneActiveFillLayerId = "zones-active-fill-layer"
    private static let zoneActiveStrokeLayerId = "zones-active-stroke-layer"
    private static let farZoomZoneHintsThreshold: Double = 12.0

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
    private var zoneStyleLoadedCancelable: AnyCancelable?
    private var zoneCameraChangedCancelable: AnyCancelable?
    private var areZoneLayersReady = false
    private var zones: [ZonePolygonPayload] = []
    private var zoneDisplayMode: ZoneDisplayMode = .hidden
    private var myZoneId: Int?
    private var affectedZoneIds: Set<Int> = []
    private var activeZoneId: Int?
    private var lastZoneRenderSignature: ZoneRenderSignature?

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

    func setZones(_ zones: [ZonePolygonPayload]) {
        self.zones = zones
        renderZonesIfPossible(force: true)
    }

    func clearZones() {
        zones = []
        hideZones()
        renderZonesIfPossible(force: true)
    }

    func hideZones() {
        zoneDisplayMode = .hidden
        myZoneId = nil
        affectedZoneIds.removeAll()
        activeZoneId = nil
        renderZonesIfPossible(force: true)
    }

    func showAllZones() {
        zoneDisplayMode = .all
        myZoneId = nil
        affectedZoneIds.removeAll()
        activeZoneId = nil
        renderZonesIfPossible(force: true)
    }

    func showMyZone(_ zoneId: Int) {
        zoneDisplayMode = .myZone
        myZoneId = zoneId
        affectedZoneIds.removeAll()
        activeZoneId = zoneId
        renderZonesIfPossible(force: true)
    }

    func showAffectedZones(_ zoneIds: [Int], activeZoneId: Int? = nil) {
        let ids = zoneIds.filter { $0 > 0 }
        zoneDisplayMode = .affected
        myZoneId = nil
        affectedZoneIds = Set(ids)
        self.activeZoneId = activeZoneId ?? ids.first
        renderZonesIfPossible(force: true)
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
        areZoneLayersReady = false
        navigationMapView.mapView.mapboxMap.mapStyle = mapStyle(for: styleIdentifier)
    }

    var cameraCenterCoordinate: CLLocationCoordinate2D {
        navigationMapView.mapView.mapboxMap.cameraState.center
    }

    func centerOnCoordinate(_ coordinate: CLLocationCoordinate2D, zoom: Double) {
        guard isValidCoordinate(coordinate) else {
            return
        }

        navigationMapView.navigationCamera.stop()
        navigationMapView.mapView.camera.ease(
            to: CameraOptions(center: coordinate, zoom: zoom, bearing: 0, pitch: 0),
            duration: 0.35
        )
    }

    func centerTurnByTurnCamera(restrictZoomOut: Bool = true) {
        configureTurnByTurnCamera(restrictZoomOut: restrictZoomOut)
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

    private func configureTurnByTurnCamera(restrictZoomOut: Bool = true) {
        guard let viewportDataSource = navigationMapView.navigationCamera.viewportDataSource as? MobileViewportDataSource else {
            return
        }

        viewportDataSource.options.followingCameraOptions.centerUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.bearingUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.pitchUpdatesAllowed = true
        viewportDataSource.options.followingCameraOptions.paddingUpdatesAllowed = false
        viewportDataSource.options.followingCameraOptions.followsLocationCourse = true
        viewportDataSource.options.followingCameraOptions.zoomRange = restrictZoomOut ? 13.75...16.35 : FollowingCameraOptions().zoomRange

        let padding = UIEdgeInsets(
            top: 200,
            left: 16,
            bottom: 60,
            right: 16
        )
        viewportDataSource.currentNavigationCameraOptions.followingCamera.padding = padding
        try? navigationMapView.mapView.mapboxMap.setCameraBounds(
            with: restrictZoomOut ? CameraBoundsOptions(minZoom: 13.75) : CameraBoundsOptions()
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
        observeZoneStyleLoaded()
        observeZoneCameraChanges()
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

    private func observeZoneStyleLoaded() {
        zoneStyleLoadedCancelable = navigationMapView.mapView.mapboxMap.onStyleLoaded.observe { [weak self] _ in
            guard let self else {
                return
            }

            self.areZoneLayersReady = false
            self.configureZoneLayersIfNeeded()
            self.renderZonesIfPossible(force: true)
        }
    }

    private func observeZoneCameraChanges() {
        zoneCameraChangedCancelable = navigationMapView.mapView.mapboxMap.onCameraChanged.observe { [weak self] _ in
            self?.renderZonesIfPossible()
        }
    }

    private func configureZoneLayersIfNeeded() {
        guard let mapboxMap = navigationMapView.mapView.mapboxMap else {
            return
        }
        guard !areZoneLayersReady else {
            return
        }

        addZoneSourceIfNeeded(id: Self.zoneHintsSourceId)
        addZoneSourceIfNeeded(id: Self.zoneVisibleSourceId)
        addZoneSourceIfNeeded(id: Self.zoneActiveSourceId)

        if !mapboxMap.layerExists(withId: Self.zoneHintsLayerId) {
            var lineLayer = LineLayer(id: Self.zoneHintsLayerId, source: Self.zoneHintsSourceId)
            lineLayer.slot = .bottom
            lineLayer.lineColor = .expression(zoneColorExpression(fallbackHex: "#6F868D"))
            lineLayer.lineOpacity = .constant(0.28)
            lineLayer.lineWidth = .constant(3) //bord zones when user go back
            try? mapboxMap.addLayer(lineLayer)
        }

        if !mapboxMap.layerExists(withId: Self.zoneVisibleFillLayerId) {
            var fillLayer = FillLayer(id: Self.zoneVisibleFillLayerId, source: Self.zoneVisibleSourceId)
            fillLayer.slot = .bottom
            fillLayer.fillColor = .expression(zoneColorExpression(fallbackHex: "#5B8794"))
            fillLayer.fillOpacity = .constant(0.43) // color zones for default
            try? mapboxMap.addLayer(fillLayer)
        }

        if !mapboxMap.layerExists(withId: Self.zoneVisibleStrokeLayerId) {
            var lineLayer = LineLayer(id: Self.zoneVisibleStrokeLayerId, source: Self.zoneVisibleSourceId)
            lineLayer.slot = .bottom
            lineLayer.lineColor = .expression(zoneColorExpression(fallbackHex: "#4D707A"))
            lineLayer.lineOpacity = .constant(0.35)
            lineLayer.lineWidth = .constant(1.1)
            try? mapboxMap.addLayer(lineLayer)
        }

        if !mapboxMap.layerExists(withId: Self.zoneActiveFillLayerId) {
            var fillLayer = FillLayer(id: Self.zoneActiveFillLayerId, source: Self.zoneActiveSourceId)
            fillLayer.slot = .bottom
            fillLayer.fillColor = .expression(zoneColorExpression(fallbackHex: "#42949E"))
            fillLayer.fillOpacity = .constant(0.3) // color my zone
            try? mapboxMap.addLayer(fillLayer)
        }

        if !mapboxMap.layerExists(withId: Self.zoneActiveStrokeLayerId) {
            var lineLayer = LineLayer(id: Self.zoneActiveStrokeLayerId, source: Self.zoneActiveSourceId)
            lineLayer.slot = .bottom
            lineLayer.lineColor = .expression(zoneColorExpression(fallbackHex: "#2E737D"))
            lineLayer.lineOpacity = .constant(0.85)
            lineLayer.lineWidth = .constant(1.5)
            try? mapboxMap.addLayer(lineLayer)
        }

        areZoneLayersReady = true
    }

    private func addZoneSourceIfNeeded(id: String) {
        guard let mapboxMap = navigationMapView.mapView.mapboxMap else {
            return
        }
        guard !mapboxMap.sourceExists(withId: id) else {
            return
        }

        var source = GeoJSONSource(id: id)
        source.data = .featureCollection(FeatureCollection(features: []))
        try? mapboxMap.addSource(source)
    }

    private func renderZonesIfPossible(force: Bool = false) {
        guard let mapboxMap = navigationMapView.mapView.mapboxMap else {
            return
        }
        configureZoneLayersIfNeeded()
        guard areZoneLayersReady else {
            return
        }

        let shouldShowHints = shouldShowZoneHints
        let visibleZones = visibleZonesForCurrentState()
        let activeZones = activeZonesForCurrentState()
        let renderSignature = ZoneRenderSignature(
            mode: zoneDisplayMode,
            zoneCount: zones.count,
            visibleZoneIds: visibleZones.map(\.idZona),
            activeZoneIds: activeZones.map(\.idZona),
            shouldShowHints: shouldShowHints
        )

        guard force || renderSignature != lastZoneRenderSignature else {
            return
        }

        let allFeatures = zones.map(makeZoneFeature(from:))
        let visibleFeatures = visibleZones.map(makeZoneFeature(from:))
        let activeFeatures = activeZones.map(makeZoneFeature(from:))
        let hintFeatures = shouldShowHints ? allFeatures : []

        mapboxMap.updateGeoJSONSource(
            withId: Self.zoneHintsSourceId,
            geoJSON: GeoJSONObject.featureCollection(FeatureCollection(features: hintFeatures))
        )
        mapboxMap.updateGeoJSONSource(
            withId: Self.zoneVisibleSourceId,
            geoJSON: GeoJSONObject.featureCollection(FeatureCollection(features: visibleFeatures))
        )
        mapboxMap.updateGeoJSONSource(
            withId: Self.zoneActiveSourceId,
            geoJSON: GeoJSONObject.featureCollection(FeatureCollection(features: activeFeatures))
        )

        lastZoneRenderSignature = renderSignature
    }

    private var shouldShowZoneHints: Bool {
        guard zoneDisplayMode == .hidden else {
            return false
        }

        let zoom = navigationMapView.mapView.mapboxMap.cameraState.zoom
        return zoom <= Self.farZoomZoneHintsThreshold
    }

    private func visibleZonesForCurrentState() -> [ZonePolygonPayload] {
        switch zoneDisplayMode {
        case .hidden:
            return []
        case .all:
            return zones
        case .myZone:
            guard let myZoneId else {
                return []
            }
            return zones.filter { $0.idZona == myZoneId }
        case .affected:
            guard !affectedZoneIds.isEmpty else {
                return []
            }
            return zones.filter { affectedZoneIds.contains($0.idZona) }
        }
    }

    private func activeZonesForCurrentState() -> [ZonePolygonPayload] {
        switch zoneDisplayMode {
        case .myZone:
            guard let activeZoneId else {
                return []
            }
            return zones.filter { $0.idZona == activeZoneId }
        case .affected:
            guard let activeZoneId else {
                return []
            }
            return zones.filter { $0.idZona == activeZoneId }
        case .all, .hidden:
            return []
        }
    }

    private func makeZoneFeature(from zone: ZonePolygonPayload) -> Feature {
        var feature = Feature(geometry: .multiPolygon(zone.geometry))
        var properties: JSONObject = [
            "idZona": .number(Double(zone.idZona))
        ]
        if let nombreZona = zone.nombreZona {
            properties["nombreZona"] = .string(nombreZona)
        }
        if let colorZona = zone.colorZona {
            properties["colorZona"] = .string(colorZona)
        }
        feature.properties = properties
        return feature
    }

    private func zoneColorExpression(fallbackHex: String) -> Exp {
        Exp(.coalesce) {
            Exp(.toColor) {
                Exp(.get) { "colorZona" }
            }
            Exp(.toColor) { fallbackHex }
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

private enum ZoneDisplayMode {
    case hidden
    case all
    case myZone
    case affected
}

private struct ZoneRenderSignature: Equatable {
    let mode: ZoneDisplayMode
    let zoneCount: Int
    let visibleZoneIds: [Int]
    let activeZoneIds: [Int]
    let shouldShowHints: Bool
}

private extension CLLocationCoordinate2D {
    func isSameCoordinate(as other: CLLocationCoordinate2D) -> Bool {
        abs(latitude - other.latitude) < 0.000001 &&
            abs(longitude - other.longitude) < 0.000001
    }
}
