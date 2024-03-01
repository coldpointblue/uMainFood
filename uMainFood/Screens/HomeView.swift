/*  Goal explanation:  Home screen for Food app   */


import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RestaurantListViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if viewModel.isRefreshingData {
                    ProgressIndicator()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.allRestaurants.isEmpty {
                    StartOverText(onTap: {
                        viewModel.refreshData()
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    RestaurantsListView(viewModel: viewModel)
                }
            }
            .onReceive(viewModel.$allRestaurants) { allRestaurants in
                viewModel.updateUI()
            }
            .navigationTitle(String.uMainSymbol)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                viewModel.fetchRestaurantsAndFilters()
            }
        }
    }
}

struct StartOverText: View {
    var onTap: () -> Void
    
    var body: some View {
        Group {
            Button(action: onTap) {
                Text("Tap\rto Start Over")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .cornerRadius(18)
            .background(Color.rcBackground)
        }
    }
}

struct ProgressIndicator: View {
    var body: some View {
        ProgressView()
            .scaleEffect(3)
            .padding()
            .onAppear {
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
