//
//  User.swift
//  imdang
//
//  Created by 임대진 on 1/15/25.
//

import Foundation

struct User: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let memberId: String
    let appleRefreshToken: String?
    let joined: Bool
}
