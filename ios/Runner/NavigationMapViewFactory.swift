import Flutter
import UIKit
import CoreLocation

final class NavigationMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
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
        NavigationPlatformView(
            frame: frame,
            viewId: viewId,
            args: args,
            messenger: messenger
        )
    }
}

final class NavigationPlatformView: NSObject, FlutterPlatformView {
    private let navigationView: NavigationMapView
    private let channel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewId: Int64,
        args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let latitude = params?["latitude"] as? CLLocationDegrees ?? 0
        let longitude = params?["longitude"] as? CLLocationDegrees ?? 0
        let title = params?["title"] as? String

        let destination = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        channel = FlutterMethodChannel(
            name: "eco_ushuaia/navigation_map_view/\(viewId)",
            binaryMessenger: messenger
        )

        navigationView = NavigationMapView(
            frame: frame,
            destinationCoordinate: destination,
            destinationTitle: title,
            onRouteInfoChanged: { [weak channel] payload in
                channel?.invokeMethod("onRouteInfoChanged", arguments: payload)
            }
        )

        super.init()
    }

    func view() -> UIView {
        navigationView
    }
}
