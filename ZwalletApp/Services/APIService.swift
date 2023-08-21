//
//  APIService.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 18/08/23.
//

import Moya

enum AuthAPIService {
    case login(email: String, password: String)
    case signup(email: String, password: String, username: String)
    case logout(token: String)
    case getUserData(token: String)
    case resetPassword(email: String, password: String)
}

extension AuthAPIService: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.158.117.176:8000")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .signup:
            return "/auth/signup"
        case .logout(let bearerToken):
            return "/auth/logout/\(bearerToken)"
        case .resetPassword:
            return "/auth/reset"
        case .getUserData:
            return "/user/myProfile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .signup:
            return .post
        case .logout:
            return .delete
        case .resetPassword:
            return .patch
        case .getUserData:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .signup(let email, let password, let username):
            return .requestParameters(parameters: ["email": email, "password": password, "username": username], encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        case .resetPassword(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .getUserData:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var defaultHeaders = ["Content-Type": "application/json"]
        
        switch self {
        case .logout(let bearerToken), .getUserData(let bearerToken):
            defaultHeaders["Authorization"] = "Bearer \(bearerToken)"
        case .login, .signup, .resetPassword:
            break
        default:
            break
        }
        
        return defaultHeaders
    }
    
    var sampleData: Data {
        return Data()  // Used for testing purposes
    }
}
