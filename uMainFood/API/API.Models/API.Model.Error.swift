/*  Goal explanation:  Error Model within API namespace   */


import Foundation

// Error Model
extension API.Model {
    struct Error: Codable {
        let error: Bool
        let reason: String
    }
}
