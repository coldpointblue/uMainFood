/*  Goal explanation:  Display Details specific to one Restaurant   */


import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: API.Model.Restaurant
    var filters: [API.Model.Filter]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImageView(
                urlString: restaurant.imageUrl,
                placeholder: UIImage.loadingPhoto()
            )
            .aspectRatio(contentMode: .fit)
            
            DetailCardView(restaurant: restaurant, filters: filters)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        return RestaurantDetailView(restaurant: API.Model.Restaurant.example, filters: [])
    }
}
