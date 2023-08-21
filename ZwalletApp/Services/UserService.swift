//
//  UserService.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 20/08/23.
//

import Foundation
import Moya
import Combine
import UIKit

class UserService {
    var authService = AuthService()
    func getLoggedInUserData(completion: @escaping (Result<UserResponseModel, Error>) -> Void) {
        let tokenValidity = authService.checkBearerTokenValidity()
        
        switch tokenValidity {
        case .valid:
            let token = authService.getBearerToken()
            NetworkService.shared.authProvider.request(.getUserData(token: token)) { result in
                switch result {
                case .success(let response):
                    if 200...299 ~= response.statusCode {
                        do {
                            let user = try response.map(UserResponseModel.self)
                            completion(.success(user))
                        } catch {
                            print("Error decoding user:", error)
                            completion(.failure(UserServiceError.decodingError(error)))
                        }
                    }
                    else {
                        completion(.failure(UserServiceError.invalidStatusCode(response.statusCode)))
                    }
                case .failure(let error):
                    completion(.failure(UserServiceError.APIError(error)))
                }
            }
        case .expired:
            completion(.failure(UserServiceError.tokenExpired))
        
        case .notFound:
            completion(.failure(UserServiceError.tokenNotFound))
        }
    }
}

enum UserServiceError: Error {
    case tokenExpired
    case tokenNotFound
    case invalidStatusCode(Int)
    case decodingError(Error)
    case APIError(MoyaError)
}

extension UserServiceError {
    
    var baseError: BaseErrorModel {
        switch self {
        case .tokenExpired:
            return BaseErrorModel(title: "Authentication Error", message: "The token has expired. Please log in again...")
        case .tokenNotFound:
            return BaseErrorModel(title: "Authentication Error", message: "Token not found. Please log in again...")
        case .decodingError(let error):
            return BaseErrorModel(title: "Decoding Error", message: "Failed to decode data: \(error.localizedDescription)")
        case .invalidStatusCode(let code):
            return BaseErrorModel(title: "Server Error", message: "Received unexpected status code: \(code).")
        default:
            return BaseErrorModel(title: "Unknown Error", message: "An Unknown Internal Error Occured.")
        }
    }
    
    var baseHTTPError: BaseHTTPErrorModel? {
        switch self {
        case .APIError(let error):
            return BaseHTTPErrorModel(title: "HTTP Response Error", message: error.response!.description, statusCode: error.response!.statusCode, errorDetails: error)
            
        // Add other cases if they provide HTTP-specific errors
        default:
            return nil
        }
    }
}


