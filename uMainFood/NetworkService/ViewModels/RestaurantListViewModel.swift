/*  Goal explanation:  Dynamic Restaurant List UI   */


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
    @Published var isRefreshingData = false
    @Published var errorMessage: String?
    
    @Published var filteredRestaurants: [API.Model.Restaurant] = []
    private var filterToRestaurantsMap: [UUID: Set<String>] = [:]
    
    private var networkService = NetworkService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var notification: UserNotification?
    
    private var hasLoadedInitialData = false
    
    func refreshData() {
        hasLoadedInitialData = false
        fetchRestaurantsAndFilters()
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
                        self?.handleCustomError(error)
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
        
        var combinedRestaurantIds: Set<String> = []
        
        for filterId in selectedFilterIds {
            if let restaurantIds = filterToRestaurantsMap[filterId] {
                combinedRestaurantIds.formUnion(restaurantIds)
            }
        }
        
        filteredRestaurants = allRestaurants.filter { restaurant in
            combinedRestaurantIds.contains(restaurant.id)
        }
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
        }
    }
}

extension RestaurantListViewModel {
    func updateUIAfterFetching() {
        updateFilterToRestaurantsMap()
        applyFilters()
    }
}

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
