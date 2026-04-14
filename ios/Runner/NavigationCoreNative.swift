import Combine
import CoreLocation
import Foundation
import MapboxDirections
import MapboxNavigationCore

@MainActor
final class NavigationCoreNative {
    private let navigationProvider: MapboxNavigationProvider
    private let navigation: NavigationController
    private let tripSession: SessionController
    private var cancellables = Set<AnyCancellable>()

    private(set) var currentNavigationRoutes: NavigationRoutes?
    private var currentRouteProgress: RouteProgress?
    private var currentSession: Session?

    var onRouteProgressPayload: (([String: Any]) -> Void)?
    var onNavigationStatePayload: (([String: Any]) -> Void)?
    var onErrorPayload: (([String: Any]) -> Void)?

    init(navigationProvider: MapboxNavigationProvider) {
        self.navigationProvider = navigationProvider
        self.navigation = navigationProvider.navigation()
        self.tripSession = navigationProvider.tripSession()

        bindNavigationUpdates()
    }

    func calculatePreviewRoute(
        origin: CLLocationCoordinate2D,
        destination: CLLocationCoordinate2D
    ) async throws -> [String: Any] {
        let options = NavigationRouteOptions(coordinates: [origin, destination])
        let request = navigationProvider.routingProvider().calculateRoutes(options: options)
        let navigationRoutes = try await request.value

        currentNavigationRoutes = navigationRoutes
        currentRouteProgress = nil

        return routePayload(
            event: "routePreviewed",
            mode: "preview",
            routes: navigationRoutes,
            isNavigating: false,
            shouldEnterRouteMode: false
        )
    }

    func startNavigation() throws -> [String: Any] {
        guard let currentNavigationRoutes else {
            throw NativeNavigationError.missingRoute
        }

        tripSession.startActiveGuidance(
            with: currentNavigationRoutes,
            startLegIndex: 0
        )

        return routePayload(
            event: "navigationStarted",
            mode: "recorrido",
            routes: currentNavigationRoutes,
            isNavigating: true,
            shouldEnterRouteMode: true
        )
    }

    func currentPayload() -> [String: Any] {
        if let progress = currentRouteProgress {
            return progressPayload(progress)
        }

        if let currentNavigationRoutes {
            return routePayload(
                event: "routeReady",
                mode: "preview",
                routes: currentNavigationRoutes,
                isNavigating: false,
                shouldEnterRouteMode: false
            )
        }

        return [
            "event": "idle",
            "mode": "idle",
            "isNavigating": false,
            "shouldEnterRouteMode": false,
            "hasRoute": false
        ]
    }

    private func bindNavigationUpdates() {
        navigation.routeProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeProgressState in
                guard let self, let routeProgress = routeProgressState?.routeProgress else {
                    return
                }

                self.currentRouteProgress = routeProgress
                self.onRouteProgressPayload?(self.progressPayload(routeProgress))
            }
            .store(in: &cancellables)

        tripSession.session
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let self else { return }

                self.currentSession = session
                self.onNavigationStatePayload?(self.sessionPayload(session))
            }
            .store(in: &cancellables)

        navigation.errors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.onErrorPayload?([
                    "event": "navigationError",
                    "message": String(describing: error)
                ])
            }
            .store(in: &cancellables)
    }

    private func routePayload(
        event: String,
        mode: String,
        routes: NavigationRoutes,
        isNavigating: Bool,
        shouldEnterRouteMode: Bool
    ) -> [String: Any] {
        let route = routes.mainRoute.route
        let steps = stepsPayload(routes: routes)

        return [
            "event": event,
            "mode": mode,
            "isNavigating": isNavigating,
            "shouldEnterRouteMode": shouldEnterRouteMode,
            "hasRoute": true,
            "distanceRemaining": route.distance,
            "durationRemaining": route.expectedTravelTime,
            "stepIndex": 0,
            "currentInstruction": steps.first?["instruction"] as? String ?? "",
            "nextManeuver": steps.dropFirst().first ?? [:],
            "steps": steps
        ]
    }

    private func progressPayload(_ progress: RouteProgress) -> [String: Any] {
        let legProgress = progress.currentLegProgress
        let stepProgress = legProgress.currentStepProgress
        let currentStep = legProgress.currentStep
        let nextStep = legProgress.upcomingStep
        let visualInstruction = stepProgress.currentVisualInstruction
        let spokenInstruction = stepProgress.currentSpokenInstruction
        let currentInstruction =
            visualInstruction?.primaryInstruction.text ??
            spokenInstruction?.text ??
            currentStep.instructions

        return [
            "event": "routeProgress",
            "mode": "recorrido",
            "isNavigating": true,
            "shouldEnterRouteMode": true,
            "hasRoute": true,
            "distanceRemaining": progress.distanceRemaining,
            "durationRemaining": progress.durationRemaining,
            "distanceTraveled": progress.distanceTraveled,
            "fractionTraveled": progress.fractionTraveled,
            "legIndex": progress.legIndex,
            "stepIndex": legProgress.stepIndex,
            "stepDistanceRemaining": stepProgress.distanceRemaining,
            "stepDurationRemaining": stepProgress.durationRemaining,
            "currentInstruction": currentInstruction,
            "currentStep": stepPayload(
                currentStep,
                legIndex: progress.legIndex,
                stepIndex: legProgress.stepIndex
            ),
            "currentVisualInstruction": visualPayload(visualInstruction),
            "currentSpokenInstruction": spokenPayload(spokenInstruction),
            "nextManeuver": nextStep.map {
                stepPayload($0, legIndex: progress.legIndex, stepIndex: legProgress.stepIndex + 1)
            } ?? [:]
        ]
    }

    private func sessionPayload(_ session: Session) -> [String: Any] {
        let state: String
        let isNavigating: Bool
        let shouldEnterRouteMode: Bool

        switch session.state {
        case .idle:
            state = "idle"
            isNavigating = false
            shouldEnterRouteMode = false
        case .freeDrive:
            state = "freeDrive"
            isNavigating = false
            shouldEnterRouteMode = false
        case .activeGuidance(let activeState):
            state = "activeGuidance.\(activeState)"
            isNavigating = true
            shouldEnterRouteMode = true
        }

        var payload = currentPayload()
        payload["event"] = "navigationStateChanged"
        payload["sessionState"] = state
        payload["isNavigating"] = isNavigating
        payload["shouldEnterRouteMode"] = shouldEnterRouteMode
        payload["mode"] = shouldEnterRouteMode ? "recorrido" : (payload["mode"] ?? "idle")
        return payload
    }

    private func stepsPayload(routes: NavigationRoutes) -> [[String: Any]] {
        routes.mainRoute.route.legs.enumerated().flatMap { legIndex, leg in
            leg.steps.enumerated().map { stepIndex, step in
                stepPayload(step, legIndex: legIndex, stepIndex: stepIndex)
            }
        }
    }

    private func stepPayload(
        _ step: RouteStep,
        legIndex: Int,
        stepIndex: Int
    ) -> [String: Any] {
        [
            "legIndex": legIndex,
            "stepIndex": stepIndex,
            "instruction": step.instructions,
            "distance": step.distance,
            "duration": step.expectedTravelTime,
            "maneuverType": step.maneuverType.rawValue,
            "maneuverDirection": step.maneuverDirection?.rawValue ?? "",
            "latitude": step.maneuverLocation.latitude,
            "longitude": step.maneuverLocation.longitude,
            "roadNames": step.names ?? []
        ]
    }

    private func visualPayload(_ visual: VisualInstructionBanner?) -> [String: Any] {
        guard let visual else { return [:] }

        return [
            "text": visual.primaryInstruction.text ?? "",
            "distanceAlongStep": visual.distanceAlongStep,
            "maneuverType": visual.primaryInstruction.maneuverType?.rawValue ?? "",
            "maneuverDirection": visual.primaryInstruction.maneuverDirection?.rawValue ?? ""
        ]
    }

    private func spokenPayload(_ spoken: SpokenInstruction?) -> [String: Any] {
        guard let spoken else { return [:] }

        return [
            "text": spoken.text,
            "ssmlText": spoken.ssmlText,
            "distanceAlongStep": spoken.distanceAlongStep
        ]
    }
}

private enum NativeNavigationError: LocalizedError {
    case missingRoute

    var errorDescription: String? {
        switch self {
        case .missingRoute:
            return "No hay una ruta calculada para iniciar navegación."
        }
    }
}
