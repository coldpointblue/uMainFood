/*  Goal explanation:  Dynamic Restaurant List UI   */


import Combine
import SwiftUI

class RestaurantListViewModel: ObservableObject {
    @Published var allRestaurants: [API.Model.Restaurant] = []
    @Published var completeFilters: [API.Model.Filter.Complete] = []
    @Published var filters: [API.Model.Filter] = []
    @Published var selectedFilterIds = Set<UUID>() {
        didSet {
            DispatchQueue.main.async {
                self.applyFilters()
            }
        }
    }
    @Published var isRefreshingData = false
    @Published var errorMessage: String?
    
    @Published var filteredRestaurants: [API.Model.Restaurant] = []
    private var filterToRestaurantsMap: [UUID: Set<String>] = [:]
    
    private var networkService = NetworkService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var notification: UserNotification?
    
    private var hasLoadedInitialData = false
    
    private var filterNameMap: [UUID: String] = [:]
    
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
        let imageFetchPublishers = filters.map { filter in
            networkService.fetchImage(from: filter.imageUrl)
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .map { (filter.id, $0) }
                .catch { [weak self] error -> Empty<(UUID, UIImage), Never> in
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                        self?.handleCustomError(error)
                    }
                    return Empty()
                }
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(imageFetchPublishers)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleCustomError(error)
                }
            }, receiveValue: { [weak self] id, image in
                if let index = self?.completeFilters.firstIndex(where: { $0.filter.id == id }) {
                    self?.completeFilters[index].image = image
                }
            })
            .store(in: &subscriptions)
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
                case .timeoutError:
                    message = "Timeout error occurred."
                    self.notification = UserNotification(title: "Timeout Error", message: message)
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
    @MainActor func updateUIAfterFetching() {
        updateFilterToRestaurantsMap()
        applyFilters()
    }
}

extension RestaurantListViewModel {
    func resolveFilterNames(for activeFilterIds: [UUID]) -> [String] {
        activeFilterIds.compactMap { filterId in
            filterNameMap[filterId]
        }
    }
    
    private func updateFilterNameMap(with filters: [API.Model.Filter]) {
        filterNameMap = filters.reduce(into: [UUID: String]()) { (result, filter) in
            result[filter.id] = filter.name
        }
    }
}

extension RestaurantListViewModel {
    func fetchRestaurantsAndFilters() {
        guard !isRefreshingData, !hasLoadedInitialData else { return }
        
        isRefreshingData = true
        resetData()
        
        let restaurantPublisher = networkService.fetchRestaurants()
            .catch { [weak self] error -> Empty<API.Model.RestaurantsResponse, Never> in
                self?.handleCustomError(error)
                return Empty(completeImmediately: true)
            }
        
        restaurantPublisher
            .flatMap { [weak self] response -> AnyPublisher<[API.Model.Filter], Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                self.allRestaurants = response.restaurants
                return self.fetchFilters(for: response.restaurants)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.processCompletion(completion)
            }, receiveValue: { [weak self] filters in
                guard let self = self else { return }
                
                // Create Complete filters, now Filters arrived
                DispatchQueue.main.async {
                    let initialCompleteFilters = filters.map {
                        API.Model.Filter.Complete(filter: $0, image: nil)
                    }
                    self.completeFilters = initialCompleteFilters
                    self.filters = filters
                    self.updateUIAfterFetching()
                    self.updateFilterNameMap(with: filters)
                    
                    // Asynchronous image fetch
                    self.fetchImagesForFilters(filters)
                }
            })
            .store(in: &subscriptions)
    }
    
    private func resetData() {
        allRestaurants = []
        filters = []
        selectedFilterIds.removeAll()
    }
    
    private func fetchFilters(for restaurants: [API.Model.Restaurant]) -> AnyPublisher<[API.Model.Filter], Never> {
        let uniqueFilterIds = Set(restaurants.flatMap { $0.filterIds })
        let filterPublishers = uniqueFilterIds.map {
            networkService.fetchFilter(by: $0)
        }
        
        return Publishers.MergeMany(filterPublishers)
            .collect()
            .catch { [weak self] error -> Just<[API.Model.Filter]> in
                self?.handleCustomError(error)
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func processCompletion(_ completion: Subscribers.Completion<Never>) {
        isRefreshingData = false
        hasLoadedInitialData = true
        
        if case let .failure(error) = completion {
            errorMessage = error.localizedDescription
            handleCustomError(error)
        }
    }
}

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
