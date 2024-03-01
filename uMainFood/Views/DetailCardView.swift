/*  Goal explanation:  View details of a restaurant and its food image   */


import SwiftUI

struct DetailCardView: View {
    let restaurant: API.Model.Restaurant
    @ObservedObject var viewModel: RestaurantListViewModel
    
    private let shiftDown = -DCConst.picSize.height/2.88
    
    var body: some View {
                DCDetailsView(title: restaurant.name,
                              subtitle: viewModel.renewFilterNames(for: restaurant.filterIds))
                .offset(y: shiftDown)
    }
}

// Constants for simpler updates
typealias DCConst = DetailCardViewConstants

struct DetailCardViewConstants {
    static let picSize = CGSize(width: 375, height: 220)
    static let overViewPadding: CGFloat = 8
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCardView(restaurant: API.Model.Restaurant.example, viewModel: RestaurantListViewModel())
    }
}
