//  ----------------------------------------------------
//
//  RestaurantsListView.swift
//  Version 1.0
//
//  Unique ID:  FDF4A244-F7EB-4939-9E54-AFC5D8D35D42
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
/*  Goal explanation:  List view with all Restaurants   */
//  ----------------------------------------------------


import SwiftUI

struct RestaurantsListView: View {
    @ObservedObject var viewModel: RestaurantListViewModel
    
    private var restaurantsToDisplay: [API.Model.Restaurant] {
        viewModel.selectedFilterIds.isEmpty ? viewModel.allRestaurants : viewModel.filteredRestaurants
    }
    
    var body: some View {
        VStack {
            FilterView(selectedFilterIds: $viewModel.selectedFilterIds, filters: viewModel.filters)
            
            List(restaurantsToDisplay, id: \.id) { restaurant in
                if viewModel.isLoading {
                    SkeletonRestaurantRowView()
                } else {
                    RestaurantRow(restaurant: restaurant)
                        .userAlert(item: $viewModel.notification)
                }
            }
            .refreshable {
                viewModel.fetchRestaurantsAndFilters()
            }
            .userAlert(item: $viewModel.notification)
        }
    }
}
