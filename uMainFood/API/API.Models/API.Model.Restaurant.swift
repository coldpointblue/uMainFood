//  ----------------------------------------------------
//
//  API.Model.Restaurant.swift
//  Version 1.0
//
//  Unique ID:  684D0E9B-BD30-474A-9937-4AD5EC136F3B
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
/*  Goal explanation:  Restaurant Model within API namespace   */
//  ----------------------------------------------------


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
