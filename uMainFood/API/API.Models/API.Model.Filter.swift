/*  Goal explanation:  Filter Model within API namespace   */


import Foundation

// Filter Model
extension API.Model {
    struct Filter: Codable, Hashable {
        let id: UUID
        let name: String
        let imageUrl: String // Adjusted naming convention to camelCase for Swift
        
        enum CodingKeys: String, CodingKey {
            case id, name, imageUrl = "image_url"
        }
    }
}
