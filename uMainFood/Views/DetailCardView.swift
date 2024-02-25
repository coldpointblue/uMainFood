/*  Goal explanation:  View details of a restaurant and its food image   */


import SwiftUI

struct DetailCardView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RCFoodImageView(imageName: "exampleImage")
                DCDetailsView(title: "Emilias Fancy Food")
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
        DetailCardView()
    }
}

