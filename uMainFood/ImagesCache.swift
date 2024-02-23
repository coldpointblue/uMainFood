//  ----------------------------------------------------
//
//  ImagesCache.swift
//  Version 1.0
//
//  Unique ID:  DD5B214A-A8EA-43A2-8587-58E9B6E17E27
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
/*  Goal explanation:  Images cache with network fetch   */
//  ----------------------------------------------------


import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func image(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }
    
    func setImage(_ image: UIImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
    }
}

class LazyImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService = NetworkService.shared
    
    @Published var isError: Bool = false
    
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
