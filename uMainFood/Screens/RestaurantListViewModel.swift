//  ----------------------------------------------------
//
//  RestaurantListViewModel.swift
//  Version 1.0
//
//  Unique ID:  CFB01AC8-CEA4-4172-A998-FEF419EB14DC
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
/*  Goal explanation:  Dynamic Restaurant List UI   */
//  ----------------------------------------------------


import Combine
import SwiftUI

class RestaurantListViewModel: ObservableObject {
    @Published var allRestaurants: [API.Model.Restaurant] = []
    @Published var filters: [API.Model.Filter] = []
    @Published var selectedFilterIds = Set<UUID>() {
        didSet {
            DispatchQueue.main.async {
                self.applyFilters()
            }
        }
    }
    @Published var filterImages: [UUID: UIImage] = [:]
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @Published var filteredRestaurants: [API.Model.Restaurant] = []
    private var filterToRestaurantsMap: [UUID: Set<String>] = [:]
    
    private var networkService = NetworkService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var notification: UserNotification?
    
    func fetchRestaurantsAndFilters() {
        guard !isLoading else { return }
        
        isLoading = true
        
        allRestaurants = []
        filters = []
        
        selectedFilterIds.removeAll()
        
        networkService.fetchRestaurants()
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> Empty<API.Model.RestaurantsResponse, Never> in
                self?.handleCustomError(error)
                return Empty(completeImmediately: true)
            }
            .flatMap { [unowned self] response -> AnyPublisher<[API.Model.Filter], NetworkError> in
                self.allRestaurants = response.restaurants
                let uniqueFilterIds = Set(response.restaurants.flatMap { $0.filterIds })
                return Publishers.MergeMany(uniqueFilterIds.map {
                    self.networkService.fetchFilter(by: $0)
                })
                .collect()
                .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                    self?.handleCustomError(error)
                }
            }, receiveValue: { [weak self] filters in
                guard let self = self else { return }
                self.filters = filters
                self.updateUIAfterFetching()
                
                self.fetchImagesForFilters(filters)
            })
            .store(in: &subscriptions)
    }
    
    private func updateFilterToRestaurantsMap() {
        // Was simpler but I am debugging async network filters
        filterToRestaurantsMap.removeAll()
        
        var allFilterUUIDs = Set<UUID>()
        for restaurant in allRestaurants {
            allFilterUUIDs.formUnion(restaurant.filterIds)
        }
        
        for filterUUID in allFilterUUIDs {
            var restaurantIdsForFilter = Set<String>()
            
            for restaurant in allRestaurants {
                if restaurant.filterIds.contains(filterUUID) {
                    restaurantIdsForFilter.insert(restaurant.id)
                }
            }
            DispatchQueue.main.async {
                // Update dictionary UUID Keys with new Sets
                self.filterToRestaurantsMap[filterUUID] = restaurantIdsForFilter
            }
        }
    }
    
    private func fetchImagesForFilters(_ filters: [API.Model.Filter]) {
        filters.forEach { filter in
            networkService.fetchImage(from: filter.imageUrl)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showAlert = true
                    }
                }, receiveValue: { [weak self] image in
                    guard let image = image else { return }
                    self?.filterImages[filter.id] = image
                })
                .store(in: &subscriptions)
        }
    }
    
    func applyFilters() {
        guard !selectedFilterIds.isEmpty else {
            filteredRestaurants = allRestaurants
            return
        }
        
        let matchingRestaurantIds: Set<String> = selectedFilterIds
            .compactMap { filterToRestaurantsMap[$0] }
            .reduce(Set<String>()) { $0.union($1) }
        
        filteredRestaurants = allRestaurants.filter { restaurant in
            matchingRestaurantIds.contains(restaurant.id)
        }
    }
    
    func fetchRestaurants() {
        networkService.fetchRestaurants()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleCustomError(error)
                }
            }, receiveValue: { [weak self] restaurantsResponse in
                self?.allRestaurants = restaurantsResponse.restaurants
            })
            .store(in: &subscriptions)
    }
    
    func toggleFilter(_ filterId: UUID) {
        if selectedFilterIds.contains(filterId) {
            selectedFilterIds.remove(filterId)
        } else {
            selectedFilterIds.insert(filterId)
        }
    }
}

extension RestaurantListViewModel {
    private func handleCustomError(_ error: Error) {
        DispatchQueue.main.async {
            let message: String
            if let networkError = error as? NetworkError {
                switch networkError {
                case .urlError(let urlError):
                    message = urlError.localizedDescription
                    self.notification = UserNotification(title: "Network Error", message: message)
                case .decodingError(let decodingError):
                    message = decodingError.localizedDescription
                    self.notification = UserNotification(title: "Data Error", message: message)
                case .genericError(let errorMessage):
                    message = errorMessage
                    self.notification = UserNotification(title: "Data Error", message: message)
                case .notConnectedToInternet:
                    message = "Internet connection seems offline."
                    self.notification = UserNotification(title: "Network Error", message: message)
                case .invalidURL, .invalidResponse, .imageDownloadError, .invalidUUID:
                    message = "An unknown network error occurred.\r" + error.localizedDescription
                    self.notification = UserNotification(title: "Error", message: message)
                }
            } else {
                message = error.localizedDescription
                self.notification = UserNotification(title: "Error", message: message)
            }
            self.showAlert = true
        }
    }
}

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
