/*  Goal explanation:  Images cache with network fetch   */


import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = NSCache<NSURL, UIImage>()
    
    func image(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }
    
    func setImage(_ image: UIImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
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
