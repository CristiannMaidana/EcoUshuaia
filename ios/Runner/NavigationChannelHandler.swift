import Flutter
import UIKit

final class NavigationChannelHandler {

    static func register(with registry: FlutterPluginRegistry) {
        guard let registrar = registry.registrar(forPlugin: "MapboxNavigationMapViewPlugin") else {
            return
        }

        registrar.register(
            MapboxNavigationMapViewFactory(),
            withId: MapboxNavigationMapViewFactory.viewType
        )
    }
}
