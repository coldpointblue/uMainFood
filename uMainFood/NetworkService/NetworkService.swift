/*  Goal explanation:  Network Service to load web data   */


import Combine
import UIKit

protocol NetworkServiceProtocol {
    func fetchRestaurants() -> AnyPublisher<API.Model.RestaurantsResponse, NetworkError>
    func fetchFilter(by id: UUID) -> AnyPublisher<API.Model.Filter, NetworkError>
    func fetchOpenStatus(for restaurantId: String) -> AnyPublisher<API.Model.OpenStatus, NetworkError>
    func sharedImagePublisher(for urlString: String) -> AnyPublisher<UIImage?, NetworkError>
    func fetchImage(from urlString: String) -> AnyPublisher<UIImage?, NetworkError>
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService() // Singleton instance
    
    private let session: URLSession
    private let queue = DispatchQueue(label: "NetworkServiceQueue", attributes: .concurrent)
    private let imageCache = ImageCache.shared
    private var imagePublishers: [URL: AnyPublisher<UIImage?, NetworkError>] = [:]
    
    private init() {
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
            .timeout(7, scheduler: DispatchQueue.global(qos: .userInitiated), customError: { URLError(.timedOut) })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let urlError = error as? URLError, urlError.code == .timedOut {
                    return .timeoutError
                } else {
                    switch error {
                    case let decodingError as Swift.DecodingError:
                        return .decodingError(decodingError)
                    case let networkError as NetworkError:
                        return networkError
                    default:
                        return NetworkError.customMap(error)
                    }
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
        
        // Reads concurrently, writes serialized to prevent race conditions
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
