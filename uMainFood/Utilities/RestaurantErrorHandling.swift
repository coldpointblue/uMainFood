/*  Goal explanation:  Custom Error Handling    */


import Foundation

extension RestaurantListViewModel {
    func handleCustomError(_ error: Error) {
        DispatchQueue.main.async {
            let message: String
            if let networkError = error as? NetworkError {
                switch networkError {
                case .urlError(let urlError):
                    message = urlError.localizedDescription
                case .decodingError(let decodingError):
                    message = decodingError.localizedDescription
                case .genericError(let errorMessage):
                    message = errorMessage
                case .notConnectedToInternet:
                    message = "Internet connection seems offline."
                case .timeoutError:
                    message = "Timeout error occurred."
                case .invalidURL, .invalidResponse, .imageDownloadError, .invalidUUID:
                    message = "An unknown network error occurred.\r" + error.localizedDescription
                }
            } else {
                message = error.localizedDescription
            }
            self.errorMessage = message
        }
    }
}

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
