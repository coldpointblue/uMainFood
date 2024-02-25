/*  Goal explanation:  Row of Filters for Restaurants   */


import SwiftUI

struct FilterView: View {
    @Binding var selectedFilterIds: Set<UUID>
    @Binding var completeFilters: [API.Model.Filter.Complete]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(completeFilters, id: \.filter.id) { (completeFilter: API.Model.Filter.Complete) in
                    let isSelected = selectedFilterIds.contains(completeFilter.filter.id)
                    let iconImage = completeFilter.image.map { Image(uiImage: $0) } ?? Image.missingWebData()
                    
                    FilterToggleButton(isOn: Binding(
                        get: { isSelected },
                        set: { newValue in
                            if newValue {
                                selectedFilterIds.insert(completeFilter.filter.id)
                            } else {
                                selectedFilterIds.remove(completeFilter.filter.id)
                                
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
        let sampleCompleteFilters: [API.Model.Filter.Complete] = [
            .init(filter: API.Model.Filter(id: UUID(), name: "PrettyFilter", imageUrl: ""), image: UIImage(systemName: "house.fill")),
            .init(filter: API.Model.Filter(id: UUID(), name: "TastyFilter", imageUrl: ""), image: UIImage(systemName: "flame.fill")),
            .init(filter: API.Model.Filter(id: UUID(), name: "OvernightFilter", imageUrl: ""), image: UIImage(systemName: "moon.stars.fill"))
        ]
        
        let completeFilters: Binding<[API.Model.Filter.Complete]> = .constant(sampleCompleteFilters)
        let selectedFilterIds: Binding<Set<UUID>> = .constant([])
        
        return FilterView(selectedFilterIds: selectedFilterIds, completeFilters: completeFilters)
    }
}
