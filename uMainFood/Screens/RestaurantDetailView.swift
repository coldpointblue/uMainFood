/*  Goal explanation:  Display Details specific to one Restaurant   */


import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: API.Model.Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImageView(
                urlString: restaurant.imageUrl,
                placeholder: UIImage.loadingPhoto()
            )
            .aspectRatio(contentMode: .fit)
            
            Text(restaurant.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Delivery Time: \(restaurant.deliveryTimeMinutes) min")
                .font(.title2)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let detailsExample: API.Model.Restaurant = API.Model.Restaurant(id: "", name: "FoodThis", rating: 5.0, filterIds: [], imageUrl: "", deliveryTimeMinutes: 20)
        
        return RestaurantDetailView(restaurant: detailsExample)
    }
}
