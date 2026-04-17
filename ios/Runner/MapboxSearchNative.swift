import CoreLocation
import Foundation
import MapboxSearch

enum MapboxSearchNativeError: LocalizedError {
    case search(operation: String, message: String)
    case suggestionNotFound

    var errorDescription: String? {
        switch self {
        case let .search(operation, message):
            return "\(operation): \(message)"
        case .suggestionNotFound:
            return "La sugerencia ya no esta disponible. Vuelve a buscar."
        }
    }
}

final class MapboxSearchNative: NSObject {
    typealias Payload = [String: Any]
    typealias PayloadList = [[String: Any]]
    typealias PayloadListCompletion = (Result<PayloadList, MapboxSearchNativeError>) -> Void
    typealias PayloadCompletion = (Result<Payload?, MapboxSearchNativeError>) -> Void

    private let searchEngine: SearchEngine
    private var pendingSuggestionsCompletion: PayloadListCompletion?
    private var pendingSelectCompletion: PayloadCompletion?
    private var cachedSuggestions: [String: SearchSuggestion] = [:]
    private var cachedSuggestionOrder: [String] = []
    private var suggestionGeneration = 0

    override init() {
        searchEngine = SearchEngine(
            defaultSearchOptions: MapboxSearchNative.defaultSearchOptions(),
            apiType: .searchBox
        )
        super.init()
        searchEngine.delegate = self
    }

    func searchAddress(query: String, completion: @escaping PayloadListCompletion) {
        searchEngine.forward(query: query, options: Self.defaultSearchOptions()) { [weak self] response in
            switch response {
            case .success(let results):
                completion(.success(results.compactMap { self?.payload(for: $0) }))
            case .failure(let error):
                completion(.failure(.search(
                    operation: "searchAddress",
                    message: error.localizedDescription
                )))
            }
        }
    }

    func searchSuggestions(query: String, completion: @escaping PayloadListCompletion) {
        pendingSuggestionsCompletion?(.success([]))
        pendingSuggestionsCompletion = completion
        searchEngine.search(query: query, options: Self.defaultSearchOptions())
    }

    func selectSuggestion(id: String, completion: @escaping PayloadCompletion) {
        guard let suggestion = cachedSuggestions[id] else {
            completion(.failure(.suggestionNotFound))
            return
        }

        pendingSelectCompletion?(.success(nil))
        pendingSelectCompletion = completion
        searchEngine.select(suggestion: suggestion)
    }

    func reverseSearch(
        coordinate: CLLocationCoordinate2D,
        completion: @escaping (Payload?) -> Void
    ) {
        let options = ReverseGeocodingOptions(
            point: coordinate,
            mode: .distance,
            limit: 1,
            countries: ["AR"],
            languages: ["es"]
        )

        searchEngine.reverse(options: options) { [weak self] response in
            switch response {
            case .success(let results):
                completion(results.first.flatMap { self?.payload(for: $0) })
            case .failure:
                completion(nil)
            }
        }
    }

    private static func defaultSearchOptions() -> SearchOptions {
        var options = SearchOptions(
            countries: ["AR"],
            languages: ["es"],
            limit: 8,
            fuzzyMatch: true,
            proximity: CLLocationCoordinate2D(latitude: -54.8019, longitude: -68.3030),
            boundingBox: BoundingBox(
                CLLocationCoordinate2D(latitude: -55.12, longitude: -69.05),
                CLLocationCoordinate2D(latitude: -54.55, longitude: -67.65)
            ),
            origin: CLLocationCoordinate2D(latitude: -54.8019, longitude: -68.3030),
            filterQueryTypes: [.address, .street, .place, .poi]
        )
        options.locale = Locale(identifier: "es_AR")
        return options
    }

    private func payload(for result: SearchResult) -> Payload {
        let address = result.address?.formattedAddress(style: .medium)
            ?? result.descriptionText
            ?? result.name

        return [
            "name": result.name,
            "address": address,
            "lat": result.coordinate.latitude,
            "lon": result.coordinate.longitude
        ]
    }

    private func payload(for suggestion: SearchSuggestion, id: String) -> Payload {
        let address = suggestion.address?.formattedAddress(style: .medium)
            ?? suggestion.descriptionText
            ?? ""

        return [
            "suggestionId": id,
            "name": suggestion.name,
            "address": address
        ]
    }

    private func shouldExposeSuggestion(_ suggestion: SearchSuggestion) -> Bool {
        switch suggestion.suggestionType {
        case .address, .POI:
            return true
        case .category, .query, .brand:
            return false
        }
    }
}

extension MapboxSearchNative: SearchEngineDelegate {
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        suggestionGeneration += 1
        cachedSuggestions.removeAll(keepingCapacity: true)
        cachedSuggestionOrder.removeAll(keepingCapacity: true)

        let payloads = suggestions
            .filter(shouldExposeSuggestion)
            .enumerated()
            .map { index, suggestion -> Payload in
                let id = "\(suggestionGeneration):\(index)"
                cachedSuggestions[id] = suggestion
                cachedSuggestionOrder.append(id)
                return payload(for: suggestion, id: id)
            }

        pendingSuggestionsCompletion?(.success(payloads))
        pendingSuggestionsCompletion = nil
    }

    func offlineResultsUpdated(
        _ results: [SearchResult],
        suggestions: [SearchSuggestion],
        searchEngine: SearchEngine
    ) {
        suggestionsUpdated(suggestions: suggestions, searchEngine: searchEngine)
    }

    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        pendingSelectCompletion?(.success(payload(for: result)))
        pendingSelectCompletion = nil
    }

    func resultsResolved(results: [SearchResult], searchEngine: SearchEngine) {
        pendingSelectCompletion?(.success(results.first.map { payload(for: $0) }))
        pendingSelectCompletion = nil
    }

    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        let error = MapboxSearchNativeError.search(
            operation: "search",
            message: searchError.localizedDescription
        )
        pendingSuggestionsCompletion?(.failure(error))
        pendingSuggestionsCompletion = nil
        pendingSelectCompletion?(.failure(error))
        pendingSelectCompletion = nil
    }
}
