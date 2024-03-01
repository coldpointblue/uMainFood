//  ----------------------------------------------------
//
//  RestaurantListDataUpdater.swift
//  Version 1.0
//
//  Unique ID:  F924DF23-4906-4920-BDBE-E43E00943752
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-29.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Data operations + updates for RestaurantListViewModel   */
//  ----------------------------------------------------


import SwiftUI

protocol RestaurantListDataUpdating {
    func updateUIAfterFetching()
    func updateFilterToRestaurantsMap()
    func updateFilterNameMap(with filters: [API.Model.Filter])
    func resolveFilterNames(for activeFilterIds: [UUID]) -> [String]
}

// MARK: - Data Update Helpers

class RestaurantListDataUpdater: RestaurantListDataUpdating {
    weak var restaurantListData: RestaurantListDataSource?
    
    init(restaurantListData: RestaurantListDataSource) {
        self.restaurantListData = restaurantListData
    }
    
    @MainActor func updateUIAfterFetching() {
        updateFilterToRestaurantsMap()
        restaurantListData?.applyFilters()
    }
    
    func updateFilterToRestaurantsMap() {
        // Was simpler but I am debugging async network filters missing
        guard let restaurantListData = restaurantListData else { return }
        
        restaurantListData.clearFilterToRestaurantsMap()
        
        var allFilterUUIDs = Set<UUID>()
        for restaurant in restaurantListData.allRestaurants {
            allFilterUUIDs.formUnion(restaurant.filterIds)
        }
        
        for filterUUID in allFilterUUIDs {
            var restaurantIdsForFilter = Set<String>()
            
            for restaurant in restaurantListData.allRestaurants {
                if restaurant.filterIds.contains(filterUUID) {
                    restaurantIdsForFilter.insert(restaurant.id)
                }
            }
            
            DispatchQueue.main.async {
                // Update dictionary UUID Keys with new Sets
                restaurantListData.newRestaurantSet(filterUUID, restaurantSet: restaurantIdsForFilter)
            }
        }
    }
    
    func resolveFilterNames(for activeFilterIds: [UUID]) -> [String] {
        guard let restaurantListData = restaurantListData else { return [] }
        
        return activeFilterIds.compactMap {
            restaurantListData.getFilterName(forId: $0)
        }
    }
    
    func updateFilterNameMap(with filters: [API.Model.Filter]) {
        guard let restaurantListData = restaurantListData else { return }
        
        restaurantListData.replaceFilterNameMap(filters.reduce(into: [UUID: String]()) { (result, filter) in
            result[filter.id] = filter.name
        })
    }
}
