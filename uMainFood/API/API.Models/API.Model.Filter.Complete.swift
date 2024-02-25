/*  Goal explanation:  Filter + image, for automatic UI update   */


import Foundation
import UIKit
import SwiftUI

extension API.Model.Filter {
    struct Complete: Hashable {
        let filter: API.Model.Filter
        var image: UIImage?
        
        init(filter: API.Model.Filter, image: UIImage? = nil) {
            self.filter = filter
            self.image = image
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(filter.id)
        }
        
        static func == (lhs: Complete, rhs: Complete) -> Bool {
            return lhs.filter.id == rhs.filter.id
        }
    }
}
