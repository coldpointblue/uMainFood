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
    static func map(_ error: Error) -> NetworkError {
        switch error {
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
        default:
            if let nsError = error as NSError? {
                let detailedErrorMessage = "Domain: \(nsError.domain), Code: \(nsError.code), Message: \(nsError.localizedDescription)"
                return .genericError(detailedErrorMessage)
            } else {
                return .genericError(error.localizedDescription)
            }
        }
    }
}

extension URLError {
    var networkError: NetworkError {
        switch code {
        case .badServerResponse:
            return .urlError(self)
        default:
            return .urlError(self)
        }
    }
}
