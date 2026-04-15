import Flutter
import UIKit

@MainActor
final class ContainerPinsChannelHandler {
    private static let channelPrefix = "eco_ushuaia/mapbox_navigation_map_view/container_pins"

    private let channel: FlutterMethodChannel
    private let coordinator: ContainerPinsCoordinator

    init(
        viewId: Int64,
        binaryMessenger: FlutterBinaryMessenger,
        coordinator: ContainerPinsCoordinator
    ) {
        self.coordinator = coordinator
        self.channel = FlutterMethodChannel(
            name: "\(Self.channelPrefix)/\(viewId)",
            binaryMessenger: binaryMessenger
        )

        bindNativeEvents()
        bindFlutterMethods()
    }

    private func bindNativeEvents() {
        coordinator.onContainerSelected = { [weak self] idContenedor in
            self?.channel.invokeMethod("onContainerSelected", arguments: [
                "idContenedor": idContenedor
            ])
        }
    }

    private func bindFlutterMethods() {
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterError(
                    code: "container_pins_unavailable",
                    message: "Container pins coordinator is not available.",
                    details: nil
                ))
                return
            }

            Task { @MainActor in
                self.handle(call, result: result)
            }
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setContainers":
            setContainers(arguments: call.arguments, result: result)
        case "clearContainers":
            coordinator.clearContainers()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setContainers(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let rawContainers = args["containers"] as? [[String: Any]] else {
            result(FlutterError(
                code: "invalid_container_args",
                message: "Container annotations payload is invalid.",
                details: nil
            ))
            return
        }

        let containers = rawContainers.compactMap(ContainerPinPayload.init(dictionary:))
        coordinator.setContainers(containers)
        result(nil)
    }
}
