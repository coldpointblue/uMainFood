//  ----------------------------------------------------
//
//  API.Model.Error.swift
//  Version 1.0
//
//  Unique ID:  334EF600-2AC6-4EE2-9F3E-3979D023EFCE
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
/*  Goal explanation:  Error Model within API namespace   */
//  ----------------------------------------------------


import Foundation

// Error Model
extension API.Model {
    struct Error: Codable {
        let error: Bool
        let reason: String
    }
}
