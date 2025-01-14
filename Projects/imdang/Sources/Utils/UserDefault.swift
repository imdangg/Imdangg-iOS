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
    @UserDefault(key: "test", defaultValue: "")
    static var test: String
    
    @UserDefault(key: "test1", defaultValue: "")
    static var test1: String
    
    @UserDefault(key: "dontSeeToday", defaultValue: false)
    static var dontSeeToday: Bool
    
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
