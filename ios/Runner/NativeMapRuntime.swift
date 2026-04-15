import CoreLocation
import Foundation
import MapboxNavigationCore

@MainActor
final class NativeMapRuntime {
    static let shared = NativeMapRuntime()

    let navigationProvider: MapboxNavigationProvider
    let navigationCore: NavigationCoreNative

    private init() {
        let provider = MapboxNavigationProvider(
            coreConfig: .init(
                // Produccion o pruebas con ubicacion real.
                //locationSource: .live
                // Para testear simulacion
                 locationSource: .simulation(
                     initialLocation: CLLocation(
                         latitude: -54.8153,
                         longitude: -68.3257
                     )
                 )
            )
        )

        self.navigationProvider = provider
        self.navigationCore = NavigationCoreNative(navigationProvider: provider)
    }
}
