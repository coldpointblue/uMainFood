/*  Goal explanation:  RestaurantsResponse Model within API namespace   */


import Foundation

// RestaurantsResponse Model
extension API.Model {
    struct RestaurantsResponse: Codable {
        let restaurants: [Restaurant]
    }
}
