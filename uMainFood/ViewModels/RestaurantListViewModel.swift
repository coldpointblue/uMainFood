/*  Goal explanation:  Dynamic Restaurant List UI   */


import Combine
import SwiftUI

protocol RestaurantListDataSource: AnyObject {
    var allRestaurants: [API.Model.Restaurant] { get set }
    var filters: [API.Model.Filter] { get set }
    var selectedFilterIds: Set<UUID> { get set }
    func applyFilters()
    func newRestaurantSet(_ filterKey: UUID, restaurantSet: Set<String>)
    func clearFilterToRestaurantsMap()
    func getFilterName(forId id: UUID) -> String?
    func replaceFilterNameMap(_ map: [UUID: String])
}

class RestaurantListViewModel: ObservableObject, RestaurantListDataSource {
    private var networkService: NetworkServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Active UI updates
    
    @Published var allRestaurants: [API.Model.Restaurant] = []
    @Published var filters: [API.Model.Filter] = []
    @Published var completeFilters: [API.Model.Filter.Complete] = []
    @Published var selectedFilterIds = Set<UUID>() {
        didSet {
            DispatchQueue.main.async {
                self.applyFilters()
            }
        }
    }
    
    @Published var filteredRestaurants: [API.Model.Restaurant] = []
    @Published var isRefreshingData = false
    @Published var errorMessage: String?
    @Published var notification: UserNotification?
    
    // MARK: - Internal State and Mappings
    
    private var filterToRestaurantsMap: [UUID: Set<String>] = [:]
    private var filterNameMap: [UUID: String] = [:]
    private var hasLoadedInitialData = false
    
    private lazy var dataUpdater: RestaurantListDataUpdater = {
        RestaurantListDataUpdater(restaurantListData: self)
    }()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Core UX functions
    
    func refreshData() {
        hasLoadedInitialData = false
        fetchRestaurantsAndFilters()
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
        
        withAnimation {
            // Priority sort with rating first, then alphabetic
            filteredRestaurants = allRestaurants.filter {
                combinedRestaurantIds.contains($0.id)
            }.sorted {
                if $0.rating == $1.rating {
                    return $0.name < $1.name
                }
                return $0.rating > $1.rating
            }
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

// MARK: - Data Fetching and Management

extension RestaurantListViewModel {
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
                    self.dataUpdater.updateUIAfterFetching()
                    self.dataUpdater.updateFilterNameMap(with: filters)
                    
                    // Asynchronous image fetch
                    self.fetchImagesForFilters(filters)
                }
            })
            .store(in: &subscriptions)
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
    
    func resetData() {
        allRestaurants = []
        filters = []
        selectedFilterIds.removeAll()
    }
}

extension RestaurantListViewModel {
    @MainActor
    func newRestaurantSet(_ filterKey: UUID, restaurantSet: Set<String>) {
        filterToRestaurantsMap[filterKey] = restaurantSet
    }
    
    func clearFilterToRestaurantsMap() {
        filterToRestaurantsMap.removeAll()
    }
    
    func getFilterName(forId id: UUID)-> String? {
        filterNameMap[id]
    }
    
    func replaceFilterNameMap(_ map: [UUID: String]) {
        self.filterNameMap = map
    }
    
    @MainActor
    func updateUI() {
        self.dataUpdater.updateUIAfterFetching()
    }
    
    func renewFilterNames(for activeFilterIds: [UUID]) -> [String] {
        dataUpdater.resolveFilterNames(for: activeFilterIds)
    }
}
