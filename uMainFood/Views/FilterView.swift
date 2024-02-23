/*  Goal explanation:  Row of Filters for Restaurants   */


import SwiftUI

struct FilterView: View {
    @Binding var selectedFilterIds: Set<UUID>
    @Binding var filters: [API.Model.Filter]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilterIds.formSymmetricDifference([filter.id])
                    }) {
                        Text(filter.name)
                            .padding()
                            .background(selectedFilterIds.contains(filter.id) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        let filters: Binding<[API.Model.Filter]> = .constant([
            API.Model.Filter(id: UUID(), name: "PrettyFilter", imageUrl: ""),
            API.Model.Filter(id: UUID(), name: "TastyFilter", imageUrl: ""),
            API.Model.Filter(id: UUID(), name: "OvernightFilter", imageUrl: "")
        ])
        let selectedFilterIds: Binding<Set<UUID>> = .constant([])
        
        return FilterView(selectedFilterIds: selectedFilterIds, filters: filters)
    }
}
