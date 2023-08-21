//
//  NetworkService.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 18/08/23.
//

import Foundation
import Moya

class NetworkService {
    static let shared = NetworkService()
    let networkLogger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    
    lazy var authProvider: MoyaProvider<AuthAPIService> = {
        return MoyaProvider<AuthAPIService>(plugins: [self.networkLogger])
    }()
    
    private init() {}
}

