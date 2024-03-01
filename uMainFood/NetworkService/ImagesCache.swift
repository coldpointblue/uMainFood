/*  Goal explanation:  Images cache with network fetch   */


import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    static private(set) var countSetCalls: Int = 0
    
    func image(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }
    
    func setImage(_ image: UIImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
        ImageCache.countSetCalls += 1
    }
}

class LazyImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isError: Bool = false
    
    private var networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImageIfNeeded(from urlString: String) {
        // Only fetch if the image hasn't been loaded
        guard image == nil else { return }
        networkService.fetchImage(from: urlString)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.isError = true
                }
            }, receiveValue: { [weak self] fetchedImage in
                self?.image = fetchedImage
            })
            .store(in: &cancellables)
    }
}
