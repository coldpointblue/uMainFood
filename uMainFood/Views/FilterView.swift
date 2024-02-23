//  ----------------------------------------------------
//
//  FilterView.swift
//  Version 1.0
//
//  Unique ID:  461D00D3-A61B-4F6C-96AF-C57EB9A74462
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
/*  Goal explanation:  Row of Filters for Restaurants   */
//  ----------------------------------------------------


import SwiftUI

struct FilterView: View {
    @Binding var selectedFilterIds: Set<UUID>
    var filters: [API.Model.Filter]
    
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
        let filters: [API.Model.Filter] = [
            API.Model.Filter(id: UUID(), name: "PrettyFilter", imageUrl: ""),
            API.Model.Filter(id: UUID(), name: "TastyFilter", imageUrl: ""),
            API.Model.Filter(id: UUID(), name: "OvernightFilter", imageUrl: "")
        ]
        let selectedFilterIds: Binding<Set<UUID>> = .constant([])
        
        return FilterView(selectedFilterIds: selectedFilterIds, filters: filters)
    }
}
