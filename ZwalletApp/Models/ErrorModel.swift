//
//  ErrorModel.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 20/08/23.
//

import Foundation
import Moya

struct BaseErrorModel {
    let title: String
    let message: String
}

struct BaseHTTPErrorModel {
    let title: String
    let message: String
    let statusCode: Int
    let errorDetails: Error
}
