//  ----------------------------------------------------
//
//  HomeView.swift
//  Version 1.0
//
//  Unique ID:  55C5E2E8-3139-487E-930B-DA107E9F384C
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-15.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Home screen for Food app   */
//  ----------------------------------------------------


import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RestaurantListViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                if viewModel.isLoading || viewModel.allRestaurants.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(3)
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    RestaurantsListView(viewModel: viewModel)
                }
            }
            .onReceive(viewModel.$allRestaurants) { allRestaurants in
                viewModel.updateUIAfterFetching()
            }
            .navigationTitle("Restaurants")
            .toolbar(.hidden, for: .tabBar)
            .task {
                viewModel.fetchRestaurantsAndFilters()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
