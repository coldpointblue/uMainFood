/*  Goal explanation:  View details of a restaurant and its food image   */


import SwiftUI

struct DetailCardView: View {
    let restaurant: API.Model.Restaurant
    var filters: [API.Model.Filter]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DCDetailsView(title: restaurant.name)
                    .offset(y: -DCConst.picSize.height/5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(DCConst.picSize.width / DCConst.picSize.height, contentMode: .fit)
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
        DetailCardView(restaurant: API.Model.Restaurant.example, filters: [])
    }
}

