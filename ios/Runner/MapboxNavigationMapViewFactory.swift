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
        MapboxNavigationPlatformView(frame: frame)
    }
}

private final class MapboxNavigationPlatformView: NSObject, FlutterPlatformView {
    private let nativeMapView: NativeMapView

    init(frame: CGRect) {
        self.nativeMapView = NativeMapView(frame: frame)
        super.init()
    }

    func view() -> UIView {
        nativeMapView
    }
}
