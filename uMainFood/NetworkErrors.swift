//  ----------------------------------------------------
//
//  NetworkErrors.swift
//  Version 1.0
//
//  Unique ID:  9A57B7C5-A46B-427A-81A7-A3A92C0D579E
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
/*  Goal explanation:  Define custom networking errors   */
//  ----------------------------------------------------


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
}

extension NetworkError {
    static func map(_ error: Error) -> NetworkError {
        switch error {
        case let urlError as URLError:
            if urlError.code == .notConnectedToInternet {
                return .notConnectedToInternet
            } else {
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
