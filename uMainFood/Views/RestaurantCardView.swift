/*  Goal explanation:  View the Restaurant Card overview info   */


import SwiftUI

struct RestaurantCardView: View {
    var body: some View {
        ZStack {
            Color(Color.clear)
            VStack(spacing: 0) {
                RCFoodImageView(imageName: "wanted_image_name")
                    .roundTopCorners()
                RCOverviewView(rating: 5, deliveryTimeInMinutes: 121, activeTags: ["Tag", "Tag", "Tag"], title: "Title")
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
        RestaurantCardView()
    }
}
