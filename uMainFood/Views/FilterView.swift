/*  Goal explanation:  Row of Filters for Restaurants   */


import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RestaurantListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.completeFilters, id: \.filter.id) { (completeFilter: API.Model.Filter.Complete) in
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
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var viewModel = RestaurantListViewModel()
        
        viewModel.completeFilters  = [
            .init(filter: API.Model.Filter(id: UUID(), name: "PrettyFilter", imageUrl: ""), image: UIImage(systemName: "house.fill")),
            .init(filter: API.Model.Filter(id: UUID(), name: "TastyFilter", imageUrl: ""), image: UIImage(systemName: "flame.fill")),
            .init(filter: API.Model.Filter(id: UUID(), name: "OvernightFilter", imageUrl: ""), image: UIImage(systemName: "moon.stars.fill"))
        ]
        
        return FilterView(viewModel: viewModel)
        
        
    }
}
