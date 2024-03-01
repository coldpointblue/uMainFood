/*  Goal explanation:  Row of Filters for Restaurants   */


import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RestaurantListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(viewModel.completeFilters, id: \.filter.id) { completeFilter in
                    filterToggleButton(for: completeFilter)
                }
            }
        }
    }
    
    @ViewBuilder
    private func filterToggleButton(for completeFilter: API.Model.Filter.Complete) -> some View {
        let isSelected = viewModel.selectedFilterIds.contains(completeFilter.filter.id)
        let iconImage = completeFilter.image.map { Image(uiImage: $0) } ?? Image.missingWebData()
        
        FilterToggleButton(isOn: Binding(
            get: { isSelected },
            set: { newValue in
                if newValue {
                    viewModel.selectedFilterIds.insert(completeFilter.filter.id)
                } else {
                    viewModel.selectedFilterIds.remove(completeFilter.filter.id)
                }
            }
        ), icon: iconImage, tag: completeFilter.filter.name)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantListViewModel(networkService: NetworkService.shared)
        
        let filterDetails = [
            ("PrettyFilter", "house.fill"),
            ("TastyFilter", "flame.fill"),
            ("OvernightFilter", "moon.stars.fill")
        ]
        
        viewModel.completeFilters = filterDetails.map { name, systemImageName in
                .init(filter: API.Model.Filter(id: UUID(), name: name, imageUrl: ""), image: UIImage(systemName: systemImageName))
        }
        
        return FilterView(viewModel: viewModel)
    }
}
