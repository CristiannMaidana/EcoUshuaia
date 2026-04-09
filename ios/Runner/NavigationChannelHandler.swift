import Flutter
import UIKit

final class NavigationChannelHandler: NSObject {
    static func register(with controller: FlutterViewController) {
        let factory = NavigationMapViewFactory(
            messenger: controller.binaryMessenger
        )

        registrar(for: controller)?.register(
            factory,
            withId: "eco_ushuaia/navigation_map_view"
        )
    }

    private static func registrar(
        for controller: FlutterViewController
    ) -> FlutterPluginRegistrar? {
        controller.registrar(forPlugin: "eco_ushuaia/navigation_map_view")
    }
}
