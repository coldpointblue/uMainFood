//  ----------------------------------------------------
//
//  API.Model.Filter.swift
//  Version 1.0
//
//  Unique ID:  60FA2DB6-40A5-4EAE-B8DF-56E400EB99F5
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-15.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Filter Model within API namespace   */
//  ----------------------------------------------------


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
