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
                locationSource: .live
            )
        )

        self.navigationProvider = provider
        self.navigationCore = NavigationCoreNative(navigationProvider: provider)
    }
}
