/*  Goal explanation:  List view with all Restaurants   */


import SwiftUI

struct RestaurantsListView: View {
    @ObservedObject var viewModel: RestaurantListViewModel
    
    private var restaurantsToDisplay: [API.Model.Restaurant] {
        viewModel.selectedFilterIds.isEmpty ? viewModel.allRestaurants : viewModel.filteredRestaurants
    }
    
    var body: some View {
        VStack {
            FilterView(viewModel: viewModel)
            List(restaurantsToDisplay, id: \.id) { restaurant in
                Group {
                    if viewModel.isRefreshingData {
                        SkeletonRestaurantRowView()
                    } else {
                        NavigationLink(destination:                         RestaurantDetailView(restaurant: restaurant, viewModel: viewModel)) {
                            RestaurantCardView(restaurant: restaurant, filters: viewModel.filters, filterNames: viewModel.resolveFilterNames(for: restaurant.filterIds))
                                .listRowInsets(EdgeInsets())
                                .userAlert(trigger: $viewModel.notification)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .background(.background)
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
