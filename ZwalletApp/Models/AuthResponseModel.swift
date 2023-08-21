//
//  AuthResponseModel.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 18/08/23.
//


struct BaseResponseModel: Codable {
    let status: Int
    let message: String
}

struct AuthResponseModel: Codable {
    let status: Int
    let message: String
    let data: AuthUserData
}

struct AuthUserData: Codable {
    let hasPin: Bool
    let id: Int
    let email: String
    let token: String
    let expiredIn: Int
    let expiredAt: Int
    let refreshToken: String
    let refreshTokenExpiredIn: Int
    let refreshTokenExpiredAt: Int

    enum CodingKeys: String, CodingKey {
        case hasPin = "hasPin"
        case id = "id"
        case email = "email"
        case token = "token"
        case expiredIn = "expired_in"
        case expiredAt = "expired_at"
        case refreshToken = "refreshToken"
        case refreshTokenExpiredIn = "refreshToken_expired_in"
        case refreshTokenExpiredAt = "refreshToken_expired_at"
    }
}


