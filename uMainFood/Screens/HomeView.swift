/*  Goal explanation:  Home screen for Food app   */


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
