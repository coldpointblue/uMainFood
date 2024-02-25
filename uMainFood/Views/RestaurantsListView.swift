/*  Goal explanation:  List view with all Restaurants   */


import SwiftUI

struct RestaurantsListView: View {
    @ObservedObject var viewModel: RestaurantListViewModel
    
    private var restaurantsToDisplay: [API.Model.Restaurant] {
        viewModel.selectedFilterIds.isEmpty ? viewModel.allRestaurants : viewModel.filteredRestaurants
    }
    
    var body: some View {
        VStack {
            FilterView(selectedFilterIds: $viewModel.selectedFilterIds, completeFilters: $viewModel.completeFilters)
            List(restaurantsToDisplay, id: \.id) { restaurant in
                if viewModel.isRefreshingData {
                    SkeletonRestaurantRowView()
                } else {
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        RestaurantRowView(restaurant: restaurant)
                            .userAlert(trigger: $viewModel.notification)
                    }
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
            .userAlert(trigger: $viewModel.notification)
        }
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantListViewModel()
        viewModel.allRestaurants = [API.Model.Restaurant(id: "1234", name: "Johnny's", rating: 4.5, filterIds: [], imageUrl: "4321", deliveryTimeMinutes: 2), API.Model.Restaurant(id: "", name: "Jenny's", rating: 5, filterIds: [], imageUrl: "", deliveryTimeMinutes: 1)]
        
        return RestaurantsListView(viewModel: viewModel)
    }
}
