/*  Goal explanation:  OpenStatus Model within API namespace   */


import Foundation

// OpenStatus Model
extension API.Model {
    struct OpenStatus: Codable {
        let restaurantId: String
        let isCurrentlyOpen: Bool
        
        enum CodingKeys: String, CodingKey {
            case restaurantId = "restaurant_id", isCurrentlyOpen = "is_currently_open"
        }
    }
}
