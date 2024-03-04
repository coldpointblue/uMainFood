/*  Goal explanation:  Endpoints to fetch current web data   */


import Foundation

enum APIEndpoint {
    case restaurants
    case filter(UUID)
    case openStatus(String)
    
    private var baseURL: URL? {
        URL(string: "https://food-delivery.umain.io/api/v1/")
    }
    
    private var path: String {
        switch self {
        case .restaurants:
            return "restaurants"
        case .filter(let id):
            return "filter/\(id.uuidString.lowercased())"
        case .openStatus(let restaurantId):
            return "open/\(restaurantId)"
        }
    }
    
    var url: URL? {
        guard let baseURL = baseURL else { return nil }
        return baseURL.appendingPathComponent(path)
    }
}
