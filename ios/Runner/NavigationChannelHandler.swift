//
//  NavigationChannelHandler.swift
//  Runner
//
//  Created by Cristian Maidana on 09/04/2026.
//

import Flutter
import UIKit

final class NavigationChannelHandler: NSObject {
    static func register(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "eco_ushuaia/navigation",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "pingNavigation":
                result("iOS nativo conectado")
            
            case "openNativeNavigation":
                let vc = NavigationViewController()
                vc.modalPresentationStyle = .fullScreen
                controller.present(vc, animated: true)
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
