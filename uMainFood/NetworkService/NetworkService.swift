//  ----------------------------------------------------
//
//  NetworkService.swift
//  Version 1.0
//
//  Unique ID:  8613B3F9-0505-4E90-94B4-487E13A90C03
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
/*  Goal explanation:  Network Service to load web data   */
//  ----------------------------------------------------


import Combine
import UIKit

class NetworkService {
    static let shared = NetworkService() // Singleton instance
    
    private let session: URLSession
    private var subscriptions = Set<AnyCancellable>()
    private var imagePublishers: [URL: AnyPublisher<UIImage?, NetworkError>] = [:]
    private let imageCache = ImageCache.shared
    private let queue = DispatchQueue(label: "NetworkServiceQueue", attributes: .concurrent)
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv13
        self.session = URLSession(configuration: sessionConfig)
    }
    
    private func fetchData<T: Decodable>(from endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .timeout(10, scheduler: DispatchQueue.global(qos: .userInitiated), customError: { URLError(.timedOut) })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                switch error {
                case let decodingError as Swift.DecodingError:
                    return .decodingError(decodingError)
                case let networkError as NetworkError:
                    return networkError
                default:
                    return NetworkError.map(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchRestaurants() -> AnyPublisher<API.Model.RestaurantsResponse, NetworkError> {
        fetchData(from: .restaurants)
    }
    
    func fetchFilter(by id: UUID) -> AnyPublisher<API.Model.Filter, NetworkError> {
        fetchData(from: .filter(id))
    }
    
    func fetchOpenStatus(for restaurantId: String) -> AnyPublisher<API.Model.OpenStatus, NetworkError> {
        fetchData(from: .openStatus(restaurantId))
    }
}

extension NetworkService {
    func sharedImagePublisher(for urlString: String) -> AnyPublisher<UIImage?, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var publisher: AnyPublisher<UIImage?, NetworkError>?
        queue.sync {
            if let existingPublisher = imagePublishers[url] {
                publisher = existingPublisher
            } else {
                let newPublisher = fetchImage(from: urlString).share().eraseToAnyPublisher()
                self.queue.async(flags: .barrier) {
                    self.imagePublishers[url] = newPublisher
                }
                publisher = newPublisher
            }
        }
        
        // Safety in case of a logical error in the code above
        guard let safePublisher = publisher else {
            return Fail(error: NetworkError.genericError("Unexpected error")).eraseToAnyPublisher()
        }
        
        return safePublisher
    }
    
    func fetchImage(from urlString: String) -> AnyPublisher<UIImage?, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return Deferred {
            Future<UIImage?, NetworkError> { promise in
                if let cachedImage = self.imageCache.image(for: url as NSURL) {
                    promise(.success(cachedImage))
                    return
                }
                
                let task = self.session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        if let urlError = error as? URLError {
                            promise(.failure(NetworkError.urlError(urlError)))
                        } else {
                            promise(.failure(NetworkError.genericError(error.localizedDescription)))
                        }
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode),
                          let data = data,
                          let image = UIImage(data: data) else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    
                    self.imageCache.setImage(image, for: url as NSURL)
                    promise(.success(image))
                }
                
                task.resume()
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
