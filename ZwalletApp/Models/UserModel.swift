//
//  UserModel.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 18/08/23.
//

import Foundation

struct UserResponseModel: Codable {
    let status: Int
    let message: String
    let data: UserDetailModel
}

struct UserDetailModel: Codable {
    let firstname: String?
    let lastname: String?
    let email: String
    let phone: String?
}
