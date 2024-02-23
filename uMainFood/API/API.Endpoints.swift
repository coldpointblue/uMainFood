//  ----------------------------------------------------
//
//  API.Endpoints.swift
//  Version 1.0
//
//  Unique ID:  6D343AAE-95F7-412E-961F-3ADEDDAF2818
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-22.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Endpoints to fetch current web data   */
//  ----------------------------------------------------


import Foundation

enum APIEndpoint {
    case restaurants
    case filter(UUID)
    case openStatus(String)
    
    var baseURL: URL? {
        URL(string: "https://food-delivery.umain.io/api/v1/")
    }
    
    var path: String {
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
