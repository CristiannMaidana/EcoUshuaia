import CoreLocation
import Flutter

struct NativeWaypointPayload {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let title: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init?(dictionary: [String: Any]) {
        guard let latitude = NativeMapCommandPayload.coordinate(from: dictionary["latitude"]),
              let longitude = NativeMapCommandPayload.coordinate(from: dictionary["longitude"])
        else {
            return nil
        }

        self.latitude = latitude
        self.longitude = longitude
        self.title = dictionary["title"] as? String
    }
}

struct NativeContainerPayload {
    let idContenedor: Int
    let title: String?
    let description: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let idResiduo: Int?
    let idZona: Int?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init?(dictionary: [String: Any]) {
        guard let id = NativeMapCommandPayload.int(from: dictionary["idContenedor"]),
              let latitude = NativeMapCommandPayload.coordinate(from: dictionary["latitude"]),
              let longitude = NativeMapCommandPayload.coordinate(from: dictionary["longitude"])
        else {
            return nil
        }

        self.idContenedor = id
        self.title = dictionary["title"] as? String
        self.description = dictionary["description"] as? String
        self.latitude = latitude
        self.longitude = longitude
        self.idResiduo = NativeMapCommandPayload.int(from: dictionary["idResiduo"])
        self.idZona = NativeMapCommandPayload.int(from: dictionary["idZona"])
    }
}

enum NativeMapCommandPayload {
    static func dictionary(from arguments: Any?) -> [String: Any] {
        arguments as? [String: Any] ?? [:]
    }

    static func coordinate(from value: Any?) -> CLLocationDegrees? {
        if let value = value as? CLLocationDegrees {
            return value
        }

        if let value = value as? NSNumber {
            return value.doubleValue
        }

        return nil
    }

    static func double(from value: Any?) -> Double? {
        if let value = value as? Double {
            return value
        }

        if let value = value as? NSNumber {
            return value.doubleValue
        }

        return nil
    }

    static func int(from value: Any?) -> Int? {
        if let value = value as? Int {
            return value
        }

        if let value = value as? NSNumber {
            return value.intValue
        }

        return nil
    }

    static func bool(from value: Any?) -> Bool? {
        if let value = value as? Bool {
            return value
        }

        if let value = value as? NSNumber {
            return value.boolValue
        }

        return nil
    }

    static func waypoints(from arguments: Any?) -> [NativeWaypointPayload] {
        let params = dictionary(from: arguments)
        let rawWaypoints = params["waypoints"] as? [[String: Any]] ?? []
        return rawWaypoints.compactMap(NativeWaypointPayload.init(dictionary:))
    }

    static func containers(from arguments: Any?) -> [NativeContainerPayload] {
        let params = dictionary(from: arguments)
        let rawContainers = params["containers"] as? [[String: Any]] ?? []
        return rawContainers.compactMap(NativeContainerPayload.init(dictionary:))
    }

    static func flutterError(
        code: String,
        message: String,
        details: Any? = nil
    ) -> FlutterError {
        FlutterError(code: code, message: message, details: details)
    }
}
