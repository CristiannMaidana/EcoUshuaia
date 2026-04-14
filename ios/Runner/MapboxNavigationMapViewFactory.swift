import Flutter
import UIKit

final class MapboxNavigationMapViewFactory: NSObject, FlutterPlatformViewFactory {
    static let viewType = "eco_ushuaia/mapbox_navigation_map_view"

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        MapboxNavigationPlatformView(frame: frame, arguments: args)
    }
}

private final class MapboxNavigationPlatformView: NSObject, FlutterPlatformView {
    private let nativeMapView: NativeMapView

    init(frame: CGRect, arguments args: Any?) {
        let params = args as? [String: Any]
        let latitude = Self.doubleValue(params?["latitude"], fallback: -54.8070)
        let longitude = Self.doubleValue(params?["longitude"], fallback: -68.3047)
        let zoom = Self.doubleValue(params?["zoom"], fallback: 13)

        self.nativeMapView = NativeMapView(
            frame: frame,
            latitude: latitude,
            longitude: longitude,
            zoom: zoom
        )
        super.init()
    }

    func view() -> UIView {
        nativeMapView
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
