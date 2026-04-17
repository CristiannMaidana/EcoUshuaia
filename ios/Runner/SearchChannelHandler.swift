import CoreLocation
import Flutter
import Foundation

final class SearchChannelHandler {
    private static var shared: SearchChannelHandler?
    private static let channelName = "eco_ushuaia/map_search"

    private let searchNative: MapboxSearchNative
    private let channel: FlutterMethodChannel

    static func register(with registry: FlutterPluginRegistry) {
        guard let registrar = registry.registrar(forPlugin: "SearchChannelHandlerPlugin") else {
            return
        }

        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )
        let handler = SearchChannelHandler(
            channel: channel,
            searchNative: MapboxSearchNative()
        )
        channel.setMethodCallHandler(handler.handle)
        shared = handler
    }

    private init(channel: FlutterMethodChannel, searchNative: MapboxSearchNative) {
        self.channel = channel
        self.searchNative = searchNative
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "searchAddress", "search":
            guard let query = stringArgument("query", from: call.arguments)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !query.isEmpty else {
                result([])
                return
            }
            searchNative.searchAddress(query: query) { response in
                result(self.flutterResult(from: response))
            }

        case "searchSuggestions":
            guard let query = stringArgument("query", from: call.arguments)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !query.isEmpty else {
                result([])
                return
            }
            searchNative.searchSuggestions(query: query) { response in
                result(self.flutterResult(from: response))
            }

        case "selectSuggestion":
            guard let suggestionId = stringArgument("suggestionId", from: call.arguments),
                  !suggestionId.isEmpty else {
                result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "selectSuggestion requiere suggestionId.",
                    details: nil
                ))
                return
            }
            searchNative.selectSuggestion(id: suggestionId) { response in
                result(self.flutterResult(from: response))
            }

        case "reverseSearch":
            guard let coordinate = coordinateArguments(from: call.arguments) else {
                result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "reverseSearch requiere lat y lon.",
                    details: nil
                ))
                return
            }
            searchNative.reverseSearch(coordinate: coordinate) { payload in
                result(payload)
            }

        case "reverseGeocode":
            guard let coordinate = coordinateArguments(from: call.arguments) else {
                result(nil)
                return
            }
            searchNative.reverseSearch(coordinate: coordinate) { payload in
                let address = payload?["address"] as? String
                let name = payload?["name"] as? String
                result(address?.isEmpty == false ? address : name)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func stringArgument(_ key: String, from arguments: Any?) -> String? {
        guard let dictionary = arguments as? [String: Any] else { return nil }
        return dictionary[key] as? String
    }

    private func coordinateArguments(from arguments: Any?) -> CLLocationCoordinate2D? {
        guard let dictionary = arguments as? [String: Any] else { return nil }
        let lat = (dictionary["lat"] as? NSNumber)?.doubleValue
            ?? (dictionary["latitude"] as? NSNumber)?.doubleValue
        let lon = (dictionary["lon"] as? NSNumber)?.doubleValue
            ?? (dictionary["longitude"] as? NSNumber)?.doubleValue

        guard let lat, let lon else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private func flutterResult<T>(from response: Result<T, MapboxSearchNativeError>) -> Any? {
        switch response {
        case .success(let payload):
            return payload
        case .failure(let error):
            return flutterError(error)
        }
    }

    private func flutterError(_ error: MapboxSearchNativeError) -> FlutterError {
        switch error {
        case .suggestionNotFound:
            return FlutterError(
                code: "SUGGESTION_NOT_FOUND",
                message: error.localizedDescription,
                details: nil
            )
        case .search:
            return FlutterError(
                code: "MAPBOX_SEARCH_ERROR",
                message: error.localizedDescription,
                details: nil
            )
        }
    }
}
