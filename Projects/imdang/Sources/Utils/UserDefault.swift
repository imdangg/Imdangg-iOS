//
//  UserDefault.swift
//  Imdangg
//
//  Created by 임대진 on 11/3/24.
//

import Foundation

enum SignInType: String {
    case apple = "apple"
    case kakao = "kakao"
    case google = "google"
}

enum UserdefaultKey {
    // 저장: UserdefaultKey.test = "~~"
    // 읽기: let test = UserdefaultKey.test
    @UserDefault(key: "isJoined", defaultValue: false)
    static var isJoined: Bool {
        didSet {
            UserdefaultKey.isSiginedIn = UserdefaultKey.isJoined
        }
    }
    
    @UserDefault(key: "isSiginedIn", defaultValue: false)
    static var isSiginedIn: Bool
    
    @UserDefault(key: "memberId", defaultValue: "")
    static var memberId: String
    
    @UserDefault(key: "memberNickname", defaultValue: "")
    static var memberNickname: String
    
    @UserDefault(key: "deviceToken", defaultValue: "")
    static var deviceToken: String
    
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    static var refreshToken: String
    
    @UserDefault(key: "expiresIn", defaultValue: nil)
    static var expiresIn: Double?
    
    @UserDefault(key: "dontSeeToday", defaultValue: "")
    static var dontSeeToday: String
    
    @UserDefault(key: "ticketReceived", defaultValue: false)
    static var ticketReceived: Bool
    
    @UserDefault(key: "homeToolTip", defaultValue: false)
    static var homeToolTip: Bool
    
    @UserDefault(key: "wirteToolTip", defaultValue: false)
    static var wirteToolTip: Bool
    
    @UserDefault(key: "couponCount", defaultValue: nil)
    static var couponCount: Int?
    
    @UserDefault(key: "signInType", defaultValue: "")
    static var signInType: String
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
