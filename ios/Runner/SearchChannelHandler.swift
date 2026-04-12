import CoreLocation
import Flutter
import UIKit

final class SearchChannelHandler {
    private let channel: FlutterMethodChannel
    private let searchService = NativeMapboxSearchService()

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "eco_ushuaia/map_search",
            binaryMessenger: messenger
        )
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "search":
            search(call.arguments, result: result)
        case "reverseGeocode":
            reverseGeocode(call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func search(_ arguments: Any?, result: @escaping FlutterResult) {
        let params = NativeMapCommandPayload.dictionary(from: arguments)
        guard let query = params["query"] as? String else {
            result(NativeMapCommandPayload.flutterError(
                code: "INVALID_ARGUMENTS",
                message: "Falta query para búsqueda"
            ))
            return
        }

        DispatchQueue.main.async { [searchService] in
            searchService.search(query: query) { response in
                switch response {
                case .success(let payload):
                    result(payload)
                case .failure(let error):
                    result(NativeMapCommandPayload.flutterError(
                        code: "SEARCH_ERROR",
                        message: error.localizedDescription
                    ))
                }
            }
        }
    }

    private func reverseGeocode(_ arguments: Any?, result: @escaping FlutterResult) {
        let params = NativeMapCommandPayload.dictionary(from: arguments)
        guard let latitude = NativeMapCommandPayload.coordinate(from: params["latitude"]),
              let longitude = NativeMapCommandPayload.coordinate(from: params["longitude"])
        else {
            result(NativeMapCommandPayload.flutterError(
                code: "INVALID_ARGUMENTS",
                message: "Faltan latitude o longitude para geocodificación inversa"
            ))
            return
        }

        DispatchQueue.main.async { [searchService] in
            searchService.reverseGeocode(
                latitude: latitude,
                longitude: longitude
            ) { response in
                switch response {
                case .success(let address):
                    result(address)
                case .failure(let error):
                    result(NativeMapCommandPayload.flutterError(
                        code: "REVERSE_GEOCODE_ERROR",
                        message: error.localizedDescription
                    ))
                }
            }
        }
    }
}
