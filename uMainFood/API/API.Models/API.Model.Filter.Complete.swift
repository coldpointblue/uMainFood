//  ----------------------------------------------------
//
//  API.Model.Filter.Complete.swift
//  Version 1.0
//
//  Unique ID:  EDAAE708-BDB8-4263-A511-A120241D57A0
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-25.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Filter + image, for automatic UI update   */
//  ----------------------------------------------------


import Foundation
import UIKit
import SwiftUI

extension API.Model.Filter {
    struct CompleteFilter: Hashable {
        let filter: API.Model.Filter
        var image: UIImage?
        
        init(filter: API.Model.Filter, image: UIImage? = nil) {
            self.filter = filter
            self.image = image
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(filter.id)
        }
        
        static func == (lhs: CompleteFilter, rhs: CompleteFilter) -> Bool {
            return lhs.filter.id == rhs.filter.id
        }
    }
}
