/*  Goal explanation:  Restaurant Model within API namespace   */


import Foundation

// Restaurant Model
extension API.Model {
    struct Restaurant: Codable {
        let id: String
        let name: String
        let rating: Double
        let filterIds: [UUID]
        let imageUrl: String
        let deliveryTimeMinutes: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name, rating, filterIds, imageUrl = "image_url", deliveryTimeMinutes = "delivery_time_minutes"
        }
    }
}

extension API.Model.Restaurant {
    static var example: API.Model.Restaurant {
        API.Model.Restaurant(id: "", name: "FoodThis", rating: 5.0, filterIds: [], imageUrl: "", deliveryTimeMinutes: 20)
    }
}
