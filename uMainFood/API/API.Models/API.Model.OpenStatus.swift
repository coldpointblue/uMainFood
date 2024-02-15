//  ----------------------------------------------------
//
//  API.Model.OpenStatus.swift
//  Version 1.0
//
//  Unique ID:  88E7DFAE-DD6E-4DEA-B28D-63B836D7D32B
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
/*  Goal explanation:  OpenStatus Model within API namespace   */
//  ----------------------------------------------------


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
