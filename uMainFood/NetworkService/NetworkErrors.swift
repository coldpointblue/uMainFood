/*  Goal explanation:  Define custom networking errors   */


import Foundation

enum NetworkError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(String)
    case imageDownloadError
    case invalidURL
    case invalidResponse
    case invalidUUID
    case notConnectedToInternet
    case timeoutError
}

extension NetworkError {
    static func customMap(_ error: Error) -> NetworkError {
        switch error {
        case let networkErrorAsIs as NetworkError:
            return networkErrorAsIs
            
        case let urlError as URLError:
            switch urlError.code {
            case .timedOut:
                return .timeoutError
            case .notConnectedToInternet:
                return .notConnectedToInternet
            default:
                return .urlError(urlError)
            }
        case let decodingError as DecodingError:
            return .decodingError(decodingError)
        case let nsError as NSError:
            let detailedErrorMessage = "Domain: \(nsError.domain), Code: \(nsError.code), Message: \(nsError.localizedDescription)"
            return .genericError(detailedErrorMessage)
        default:
            return .genericError(error.localizedDescription)
        }
    }
}

extension NetworkError {
    static func mapToErrorMessage(_ error: Error) -> String {
        let customNetworkError = customMap(error)
        
        switch customNetworkError {
        case .urlError(let urlError):
            return urlError.localizedDescription
        case .decodingError(let decodingError):
            return decodingError.localizedDescription
        case .notConnectedToInternet:
            return "Internet connection seems offline."
        case .timeoutError:
            return "Timeout error occurred."
        case .invalidURL, .invalidResponse, .imageDownloadError, .invalidUUID:
            return "An unknown network error occurred. \(customNetworkError.localizedDescription)"
        case .genericError(let errorMessage):
            return errorMessage
        }
    }
}

extension URLError {
    var networkError: NetworkError {
        switch code {
        case .badServerResponse:
            return .invalidResponse
        default:
            return .urlError(self)
        }
    }
}
