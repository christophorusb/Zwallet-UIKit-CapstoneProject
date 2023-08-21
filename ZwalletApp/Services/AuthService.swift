//
//  AuthService.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 19/08/23.
//

import Foundation
import Moya
import Combine
import UIKit

class AuthService {
    
    enum APIError: Error {
        case decodingError(Error)
        case invalidStatusCode(Int)
        // Add other error cases
    }
    
    enum TokenStatus {
        case valid
        case expired
        case notFound
    }

    
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthResponseModel, Error>) -> Void) {
        NetworkService.shared.authProvider.request(.login(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                if 200...299 ~= response.statusCode {
                    do {
                        let user = try response.map(AuthResponseModel.self)
                        self.storeBearerToken(token: user.data.token, tokenExpiresIn: user.data.expiredIn)
                        completion(.success(user))
                    } catch {
                        print("Error decoding user:", error)
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidStatusCode(response.statusCode)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUpUser(username: String, email: String, password: String, completion: @escaping (Result<BaseResponseModel, Error>) -> Void) {
        NetworkService.shared.authProvider.request(.signup(email: email, password: password, username: username)) { result in
            switch result {
            case .success(let response):
                if 200...299 ~= response.statusCode {
                    do {
                        let apiResponse = try response.map(BaseResponseModel.self)
                        completion(.success(apiResponse))
                    } catch {
                        print("Error decoding:", error)
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidStatusCode(response.statusCode)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(bearerToken: String, completion: @escaping (Result<BaseResponseModel, Error>) -> Void) {
        NetworkService.shared.authProvider.request(.logout(token: bearerToken)) { result in
            switch result {
            case .success(let response):
                if 200...299 ~= response.statusCode {
                    do {
                        let apiResponse = try response.map(BaseResponseModel.self)
                        self.removeBearerToken()
                        completion(.success(apiResponse))
                    } catch {
                        print("Error decoding:", error)
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidStatusCode(response.statusCode)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resetPassword(email: String, password: String, completion: @escaping (Result<BaseResponseModel, Error>) -> Void) {
        NetworkService.shared.authProvider.request(.resetPassword(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                if 200...299 ~= response.statusCode {
                    do {
                        let apiResponse = try response.map(BaseResponseModel.self)
                        completion(.success(apiResponse))
                    } catch {
                        print("Error decoding:", error)
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidStatusCode(response.statusCode)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func storeBearerToken(token: String, tokenExpiresIn: Int) {
        let tokenReceivedTime = Date().timeIntervalSince1970 * 1000  // Current time in milliseconds
        let tokenExpiryTime = Int(tokenReceivedTime) + tokenExpiresIn
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "bearerToken")
        defaults.set(tokenExpiryTime, forKey: "tokenExpiresAt")
    }
    
    func checkBearerTokenValidity() -> TokenStatus {
        let defaults = UserDefaults.standard
        let tokenExpiresAt = defaults.double(forKey: "tokenExpiresAt")
        let currentTime = Date().timeIntervalSince1970 * 1000 // Current time in milliseconds
        if currentTime > tokenExpiresAt {
            return .expired
        } else {
            return .valid
        }
    }

    func getBearerToken() -> String {
        switch checkBearerTokenValidity() {
        case .valid:
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "bearerToken") {
                return token
            } else {
                return "TOKEN_NOT_FOUND"
            }
        case .expired:
            return "TOKEN_EXPIRED"
        case .notFound:
            return "TOKEN_NOT_FOUND"
        }
    }
    
    func removeBearerToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "bearerToken")
        defaults.removeObject(forKey: "tokenExpiresAt")
    }
    
    func redirectToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let navigationController = UINavigationController(rootViewController: loginViewController)
            
            // Retrieve the window from the SceneDelegate
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = navigationController
                }, completion: nil)
            }
        }
    }
}
