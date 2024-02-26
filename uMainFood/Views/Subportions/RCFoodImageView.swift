/*  Goal explanation:  View with image of food from specific restaurant   */


import SwiftUI

// Image view with conditional loading
struct RCFoodImageView: View {
    let restaurant: API.Model.Restaurant
    var filters: [API.Model.Filter]
    
    let imageName: String
    @State private var showErrorImage = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AsyncImageView(urlString: restaurant.imageUrl, placeholder: UIImage(named: "placeholderImage") ?? UIImage.missingWebData())
                    .aspectRatio(DCConst.picSize, contentMode: .fill)
                    .clipped()
            }
        }
        .onAppear {
            if UIImage(named: imageName) == nil {
                showErrorImage = true
            }
        }
        .frame(width: RCVConst.picSize.width, height: RCVConst.picSize.height)
        .aspectRatio(DCConst.picSize.width / DCConst.picSize.height, contentMode: .fit)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color.red.opacity(0.09)
            Image(uiImage: UIImage.loadingPhoto())
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(.grayPlaceholderShadeColor)
                .frame(width: RCVConst.picSize.width, height: RCVConst.picSize.height)
                .font(.system(size: 100))
        }
    }
}

struct RCFoodImageView_Previews: PreviewProvider {
    static var previews: some View {
        RCFoodImageView(restaurant: API.Model.Restaurant.example, filters: [], imageName: "Fancy Place")
    }
}
