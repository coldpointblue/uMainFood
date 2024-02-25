/*  Goal explanation:  View the Restaurant Card overview info   */


import SwiftUI

struct RestaurantCardView: View {
    var restaurant: API.Model.Restaurant
    var filters: [API.Model.Filter]

    private func resolveFilterNames() -> [String] {
        restaurant.filterIds.compactMap { id in
            filters.first(where: { $0.id == id })?.name
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RCFoodImageView(imageName: restaurant.name)
                    .roundTopCorners()
                RCOverviewView(rating: restaurant.rating, deliveryTimeInMinutes: restaurant.deliveryTimeMinutes, activeTags: resolveFilterNames(), title: restaurant.name)
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
        RestaurantCardView(restaurant: API.Model.Restaurant.example,
                           filters: viewModel.filters)
    }
}
