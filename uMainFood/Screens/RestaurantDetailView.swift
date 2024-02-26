/*  Goal explanation:  Display Details specific to one Restaurant   */


import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: API.Model.Restaurant
    @ObservedObject var viewModel: RestaurantListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImageView(
                urlString: restaurant.imageUrl,
                placeholder: UIImage.loadingPhoto()
            )
            .aspectRatio(contentMode: .fit)
            
            DetailCardView(restaurant: restaurant, viewModel: viewModel)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        return RestaurantDetailView(restaurant: API.Model.Restaurant.example, viewModel: RestaurantListViewModel())
    }
}
