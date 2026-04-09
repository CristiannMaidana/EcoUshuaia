import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidChangeAuthorization(_ status: CLAuthorizationStatus)
    func locationServiceDidUpdateLocation(_ location: CLLocation)
    func locationServiceDidFail(_ error: Error)
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermissionAndStartIfNeeded() {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()

            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()

            case .denied, .restricted:
                delegate?.locationServiceDidChangeAuthorization(locationManager.authorizationStatus)

            @unknown default:
                break
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            delegate?.locationServiceDidChangeAuthorization(manager.authorizationStatus)

            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()

            case .denied, .restricted, .notDetermined:
                break

            @unknown default:
                break
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationServiceDidUpdateLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationServiceDidFail(error)
    }
}
