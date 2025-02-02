//
//  UserDefault.swift
//  Imdangg
//
//  Created by 임대진 on 11/3/24.
//

import Foundation

enum UserdefaultKey {
    // 저장: UserdefaultKey.test = "~~"
    // 읽기: let test = UserdefaultKey.test
    @UserDefault(key: "isJoined", defaultValue: false)
    static var isJoined: Bool
    
    @UserDefault(key: "memberId", defaultValue: "")
    static var memberId: String
    
    @UserDefault(key: "deviceToken", defaultValue: "")
    static var deviceToken: String
    
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String
    
    @UserDefault(key: "dontSeeToday", defaultValue: "")
    static var dontSeeToday: String
    
    @UserDefault(key: "ticketReceived", defaultValue: false)
    static var ticketReceived: Bool
    
    @UserDefault(key: "couponCount", defaultValue: nil)
    static var couponCount: Int?
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
