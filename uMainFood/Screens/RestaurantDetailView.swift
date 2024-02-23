//  ----------------------------------------------------
//
//  RestaurantDetailView.swift
//  Version 1.0
//
//  Unique ID:  0AA71E84-895B-4A45-A24D-0A9B6751C393
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-23.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Display Details specific to one Restaurant   */
//  ----------------------------------------------------


import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: API.Model.Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImageView(
                urlString: restaurant.imageUrl,
                placeholder: UIImage(systemName: "photo") ?? UIImage()
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
