/*  Goal explanation:  Row for Restaurants list   */


import SwiftUI

struct RestaurantRowView: View {
    let restaurant: API.Model.Restaurant
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImageView(
                urlString: restaurant.imageUrl,
                placeholder: UIImage.loadingPhoto()
            )
            .frame(width: 50, height: 50)
            .background(Color.gray.opacity(0.3))
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                
                Text("Delivery: \(restaurant.deliveryTimeMinutes) min")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct RestaurantRow_Previews: PreviewProvider {
    static var previews: some View {
        let restaurantExample: API.Model.Restaurant = API.Model.Restaurant(id: "", name: "FoodThis", rating: 5.0, filterIds: [], imageUrl: "", deliveryTimeMinutes: 20)
        
        return RestaurantRowView(restaurant: restaurantExample)
    }
}
