import Flutter
import UIKit

@MainActor
final class MapboxNavigationMapViewFactory: NSObject, @MainActor FlutterPlatformViewFactory {
    static let viewType = "eco_ushuaia/mapbox_navigation_map_view"

    private let binaryMessenger: FlutterBinaryMessenger
    private var navigationChannelHandlers: [Int64: NavigationChannelHandler] = [:]
    private var containerPinsChannelHandlers: [Int64: ContainerPinsChannelHandler] = [:]

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let params = args as? [String: Any]
        let latitude = Self.doubleValue(params?["latitude"], fallback: -54.8070)
        let longitude = Self.doubleValue(params?["longitude"], fallback: -68.3047)
        let zoom = Self.doubleValue(params?["zoom"], fallback: 13)
        let runtime = NativeMapRuntime.shared

        let nativeMapView = NativeMapView(
            frame: frame,
            runtime: runtime,
            latitude: latitude,
            longitude: longitude,
            zoom: zoom
        )

        navigationChannelHandlers[viewId] = NavigationChannelHandler(
            viewId: viewId,
            binaryMessenger: binaryMessenger,
            runtime: runtime,
            mapView: nativeMapView
        )
        containerPinsChannelHandlers[viewId] = ContainerPinsChannelHandler(
            viewId: viewId,
            binaryMessenger: binaryMessenger,
            coordinator: nativeMapView.containerPinsCoordinator
        )

        return nativeMapView
    }

    private static func doubleValue(_ value: Any?, fallback: Double) -> Double {
        if let double = value as? Double {
            return double
        }
        if let int = value as? Int {
            return Double(int)
        }
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        return fallback
    }
}
