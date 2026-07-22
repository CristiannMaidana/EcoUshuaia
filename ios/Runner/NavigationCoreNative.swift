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
    private var currentProfileIdentifier: ProfileIdentifier = .automobile
    private var isRerouting = false
    private var lastEmittedProgressSignature: String?
    private var lastProgressEmissionDate: Date = .distantPast
    private let minimumProgressEmissionInterval: TimeInterval = 0.35

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
        coordinates: [CLLocationCoordinate2D],
        profileIdentifier: ProfileIdentifier
    ) async throws -> [String: Any] {
        tripSession.setToIdle()
        currentRouteProgress = nil
        currentProfileIdentifier = profileIdentifier
        isRerouting = false
        resetProgressEmissionState()

        let options = NavigationRouteOptions(
            coordinates: coordinates,
            profileIdentifier: profileIdentifier
        )
        let request = navigationProvider.routingProvider().calculateRoutes(options: options)
        let navigationRoutes = try await request.value

        currentNavigationRoutes = navigationRoutes

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

        resetProgressEmissionState()

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

    func cancelNavigation() -> [String: Any] {
        tripSession.setToIdle()
        currentRouteProgress = nil
        currentNavigationRoutes = nil
        isRerouting = false
        resetProgressEmissionState()

        return [
            "event": "navigationCancelled",
            "mode": "idle",
            "sessionState": "idle",
            "isNavigating": false,
            "shouldEnterRouteMode": false,
            "hasRoute": false,
            "isRerouting": false
        ]
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
            "hasRoute": false,
            "isRerouting": false
        ]
    }

    private func bindNavigationUpdates() {
        navigation.routeProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeProgressState in
                guard let self, let routeProgress = routeProgressState?.routeProgress else {
                    return
                }

                let previousRouteId = self.currentNavigationRoutes?.mainRoute.routeId
                self.currentNavigationRoutes = routeProgress.navigationRoutes
                self.currentRouteProgress = routeProgress

                if self.isRerouting,
                   let previousRouteId,
                   previousRouteId != routeProgress.navigationRoutes.mainRoute.routeId {
                    self.isRerouting = false
                    self.onNavigationStatePayload?(
                        self.routeStatePayload(
                            event: "rerouteApplied",
                            routes: routeProgress.navigationRoutes,
                            isNavigating: true,
                            shouldEnterRouteMode: true,
                            extra: [
                                "sessionState": self.sessionStateString(self.currentSession),
                                "currentInstruction": "Nuevo recorrido aplicado.",
                                "isRerouting": false
                            ]
                        )
                    )
                }

                self.emitProgressIfNeeded(routeProgress)
            }
            .store(in: &cancellables)

        tripSession.navigationRoutes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] navigationRoutes in
                guard let self, let navigationRoutes else {
                    return
                }

                let previousRouteId = self.currentNavigationRoutes?.mainRoute.routeId
                self.currentNavigationRoutes = navigationRoutes

                guard self.isRerouting,
                      let previousRouteId,
                      previousRouteId != navigationRoutes.mainRoute.routeId else {
                    return
                }

                self.isRerouting = false
                self.onNavigationStatePayload?(
                    self.routeStatePayload(
                        event: "rerouteApplied",
                        routes: navigationRoutes,
                        isNavigating: true,
                        shouldEnterRouteMode: true,
                        extra: [
                            "sessionState": self.sessionStateString(self.currentSession),
                            "currentInstruction": "Nuevo recorrido aplicado.",
                            "isRerouting": false
                        ]
                    )
                )
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

        navigation.rerouting
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }

                if let payload = self.reroutingPayload(status) {
                    self.onNavigationStatePayload?(payload)
                }
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
            "routeProfile": profilePayload(currentProfileIdentifier),
            "isRerouting": isRerouting,
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
            "routeProfile": profilePayload(currentProfileIdentifier),
            "isRerouting": isRerouting,
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
        let isNavigating: Bool
        let shouldEnterRouteMode: Bool

        switch session.state {
        case .idle:
            isNavigating = false
            shouldEnterRouteMode = false
        case .freeDrive:
            isNavigating = false
            shouldEnterRouteMode = false
        case .activeGuidance(let activeState):
            isNavigating = true
            shouldEnterRouteMode = true
        }

        var payload = currentPayload()
        payload["event"] = "navigationStateChanged"
        payload["sessionState"] = sessionStateString(session)
        payload["isNavigating"] = isNavigating
        payload["shouldEnterRouteMode"] = shouldEnterRouteMode
        payload["isRerouting"] = isRerouting
        payload["mode"] = shouldEnterRouteMode ? "recorrido" : (payload["mode"] ?? "idle")
        return payload
    }

    private func routeStatePayload(
        event: String,
        routes: NavigationRoutes,
        isNavigating: Bool,
        shouldEnterRouteMode: Bool,
        extra: [String: Any] = [:]
    ) -> [String: Any] {
        var payload = routePayload(
            event: event,
            mode: shouldEnterRouteMode ? "recorrido" : "preview",
            routes: routes,
            isNavigating: isNavigating,
            shouldEnterRouteMode: shouldEnterRouteMode
        )

        for (key, value) in extra {
            payload[key] = value
        }

        return payload
    }

    private func reroutingPayload(_ status: ReroutingStatus) -> [String: Any]? {
        switch status.event {
        case is ReroutingStatus.Events.FetchingRoute:
            isRerouting = true

            var payload = currentPayload()
            payload["event"] = "reroutingStateChanged"
            payload["mode"] = "recorrido"
            payload["isNavigating"] = true
            payload["shouldEnterRouteMode"] = true
            payload["sessionState"] = sessionStateString(currentSession)
            payload["isRerouting"] = true
            payload["currentInstruction"] = "Recalculando recorrido..."
            return payload

        case is ReroutingStatus.Events.Interrupted:
            isRerouting = false

            var payload = currentPayload()
            payload["event"] = "reroutingInterrupted"
            payload["sessionState"] = sessionStateString(currentSession)
            payload["isRerouting"] = false
            return payload

        case let failed as ReroutingStatus.Events.Failed:
            isRerouting = false

            var payload = currentPayload()
            payload["event"] = "reroutingFailed"
            payload["sessionState"] = sessionStateString(currentSession)
            payload["isRerouting"] = false
            payload["message"] = failed.error.localizedDescription
            return payload

        case is ReroutingStatus.Events.Fetched:
            return nil

        default:
            return nil
        }
    }

    private func sessionStateString(_ session: Session?) -> String {
        guard let session else {
            return "idle"
        }

        switch session.state {
        case .idle:
            return "idle"
        case .freeDrive:
            return "freeDrive"
        case .activeGuidance(let activeState):
            return "activeGuidance.\(activeState)"
        }
    }

    private func resetProgressEmissionState() {
        lastEmittedProgressSignature = nil
        lastProgressEmissionDate = .distantPast
    }

    private func emitProgressIfNeeded(_ progress: RouteProgress) {
        let payload = progressPayload(progress)
        let signature = progressSignature(from: payload)
        let now = Date()

        let enoughTimePassed =
            now.timeIntervalSince(lastProgressEmissionDate) >= minimumProgressEmissionInterval

        let didChangeMeaningfully =
            signature != lastEmittedProgressSignature

        guard enoughTimePassed || didChangeMeaningfully else {
            return
        }

        lastProgressEmissionDate = now
        lastEmittedProgressSignature = signature
        onRouteProgressPayload?(payload)
    }

    private func progressSignature(from payload: [String: Any]) -> String {
        let instruction = payload["currentInstruction"] as? String ?? ""
        let stepIndex = payload["stepIndex"] as? Int ?? -1
        let legIndex = payload["legIndex"] as? Int ?? -1

        let distanceRemaining: Int = {
            if let value = payload["distanceRemaining"] as? Double {
                return Int(value.rounded())
            }
            if let value = payload["distanceRemaining"] as? NSNumber {
                return Int(value.doubleValue.rounded())
            }
            return -1
        }()

        let durationRemaining: Int = {
            if let value = payload["durationRemaining"] as? Double {
                return Int(value.rounded())
            }
            if let value = payload["durationRemaining"] as? NSNumber {
                return Int(value.doubleValue.rounded())
            }
            return -1
        }()

        let isReroutingValue: Bool = {
            if let value = payload["isRerouting"] as? Bool {
                return value
            }
            if let value = payload["isRerouting"] as? NSNumber {
                return value.boolValue
            }
            return false
        }()

        return "\(legIndex)|\(stepIndex)|\(distanceRemaining)|\(durationRemaining)|\(instruction)|\(isReroutingValue)"
    }

    private func stepsPayload(routes: NavigationRoutes) -> [[String: Any]] {
        routes.mainRoute.route.legs.enumerated().flatMap { legIndex, leg in
            leg.steps.enumerated().map { stepIndex, step in
                stepPayload(step, legIndex: legIndex, stepIndex: stepIndex)
            }
        }
    }

    private func profilePayload(_ profileIdentifier: ProfileIdentifier) -> String {
        switch profileIdentifier {
        case .walking:
            return "walking"
        case .cycling:
            return "cycling"
        default:
            return "automobile"
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
