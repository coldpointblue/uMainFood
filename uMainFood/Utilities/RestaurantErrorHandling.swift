/*  Goal explanation:  Custom Error Handling    */


import Foundation

extension RestaurantListViewModel {
    func handleCustomError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = NetworkError.mapToErrorMessage(error)
        }
    }
}

struct UserNotification: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
