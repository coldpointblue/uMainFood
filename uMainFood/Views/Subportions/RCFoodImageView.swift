/*  Goal explanation:  View with image of food from specific restaurant   */


import SwiftUI

// Image view with conditional loading
struct RCFoodImageView: View {
    let imageName: String
    @State private var showErrorImage = false
    
    var body: some View {
        Group {
            if let image = UIImage(named: imageName), !showErrorImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(RCVConst.picSize, contentMode: .fill)
                    .clipped()
            } else {
                placeholderImage
            }
        }
        .onAppear {
            if UIImage(named: imageName) == nil {
                showErrorImage = true
            }
        }
        .frame(width: RCVConst.picSize.width, height: RCVConst.picSize.height)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color.red.opacity(0.09)
            Image(systemName: "photo")
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
        RCFoodImageView(imageName: "exampleImage")
    }
}
