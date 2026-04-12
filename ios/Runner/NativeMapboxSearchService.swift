import CoreLocation
import Foundation
import MapboxSearch
import MapboxSearchUI

final class NativeMapboxSearchService {
    private let searchEngine: SearchEngine

    init() {
        searchEngine = SearchEngine(
            defaultSearchOptions: SearchOptions(
                countries: ["AR"],
                languages: ["es"],
                limit: 10,
                filterQueryTypes: [.address, .place]
            ),
            apiType: .searchBox
        )
    }

    func search(
        query: String,
        completion: @escaping (Result<[[String: Any]], Error>) -> Void
    ) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion(.success([]))
            return
        }

        searchEngine.forward(query: trimmed) { response in
            switch response {
            case .success(let results):
                completion(.success(results.map(Self.payload(for:))))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func reverseGeocode(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        let options = ReverseGeocodingOptions(
            point: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            limit: 1,
            filterQueryTypes: [.address],
            countries: ["AR"],
            languages: ["es"]
        )

        searchEngine.reverse(options: options) { response in
            switch response {
            case .success(let results):
                completion(.success(results.first.map(Self.displayName(for:))))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private static func payload(for result: SearchResult) -> [String: Any] {
        [
            "latitude": result.coordinate.latitude,
            "longitude": result.coordinate.longitude,
            "name": result.name,
            "address": result.descriptionText ?? displayName(for: result)
        ]
    }

    private static func displayName(for result: SearchResult) -> String {
        if let description = result.descriptionText,
           !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return description
        }

        if let address = result.address?.formattedAddress(style: .medium),
           !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return address
        }

        return result.name
    }
}
