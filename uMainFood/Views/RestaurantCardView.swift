/*  Goal explanation:  View the Restaurant Card overview info   */


import SwiftUI

struct RestaurantCardView: View {
    var restaurant: API.Model.Restaurant
    var filters: [API.Model.Filter]
    var filterNames: [String]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RCFoodImageView(restaurant: restaurant, filters: filters, imageName: restaurant.name)
                    .roundTopCorners()
                RCOverviewView(rating: restaurant.rating, deliveryTimeInMinutes: restaurant.deliveryTimeMinutes, activeTags: filterNames, title: restaurant.name)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(RCVConst.picSize.width / RCVConst.picSize.height, contentMode: .fit)
        }
    }
}

// Constants for simpler updates
typealias RCVConst = RestaurantCardViewConst

struct RestaurantCardViewConst {
    static let picSize = CGSize(width: 375, height: 220)
    static let overViewPadding: CGFloat = 8
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantListViewModel()
        let example = API.Model.Restaurant.example
        
        
        return RestaurantCardView(restaurant: example, filters: viewModel.filters, filterNames: viewModel.resolveFilterNames(for: example.filterIds))
    }
}
