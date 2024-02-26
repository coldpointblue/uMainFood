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

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
