//  ----------------------------------------------------
//
//  API.Model.RestaurantsResponse.swift
//  Version 1.0
//
//  Unique ID:  51E22797-8150-440F-93ED-B81A44E5F71C
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
/*  Goal explanation:  RestaurantsResponse Model within API namespace   */
//  ----------------------------------------------------


import Foundation

// RestaurantsResponse Model
extension API.Model {
    struct RestaurantsResponse: Codable {
        let restaurants: [Restaurant]
    }
}
