//
//  CoreData.swift
//  WhatHa
//
//  Created by kim jason on 09/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation

protocol KeyNamespaceable {
}

extension KeyNamespaceable {
    private static func namespace(_ key: String) -> String {
        return "\(Self.self).\(key)"
    }
    
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        return namespace(key.rawValue)
    }
}

// MARK: - String Defaults
protocol StringUserDefaultable: KeyNamespaceable {
    associatedtype StringDefaultKey: RawRepresentable
}

extension StringUserDefaultable where StringDefaultKey.RawValue == String {
    
    // 모든 String 으로 저장 하는 것들은 RSA 암호화를 거쳐서 합니다.
    // Set
    static func set(_ value: String, forKey key: StringDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // Get
    static func string(forKey key: StringDefaultKey) -> String {
        let key = namespace(key)
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        return value
    }
    
}


// MARK: - Bool Defaults
protocol BoolUserDefaultable: KeyNamespaceable {
    associatedtype BoolDefaultKey: RawRepresentable
}

extension BoolUserDefaultable where BoolDefaultKey.RawValue == String {
    
    // Set
    static func set(_ bool: Bool, forKey key: BoolDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(bool, forKey: key)
    }
    
    // Get
    static func bool(forKey key: BoolDefaultKey) -> Bool {
        let key = namespace(key)
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
}


// MARK: - Float Defaults
protocol FloatUserDefaultable: KeyNamespaceable {
    associatedtype FloatDefaultKey: RawRepresentable
}

extension FloatUserDefaultable where FloatDefaultKey.RawValue == String {
    
    // Set
    static func set(_ float: Float, forKey key: FloatDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(float, forKey: key)
    }
    
    // Get
    static func float(forKey key: FloatDefaultKey) -> Float {
        let key = namespace(key)
        let value = UserDefaults.standard.float(forKey: key)
        return value
    }
}


// MARK: - Integer Defaults
protocol IntegerUserDefaultable: KeyNamespaceable {
    associatedtype IntegerDefaultKey: RawRepresentable
}

extension IntegerUserDefaultable where IntegerDefaultKey.RawValue == String {
    
    // Set
    static func set(_ integer: Int, forKey key: IntegerDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(integer, forKey: key)
    }
    
    // Get
    static func integer(forKey key: IntegerDefaultKey) -> Int {
        let key = namespace(key)
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
}


// MARK: - Object Defaults
protocol ObjectUserDefaultable: KeyNamespaceable {
    associatedtype ObjectDefaultKey: RawRepresentable
}

extension ObjectUserDefaultable where ObjectDefaultKey.RawValue == String {
    
    // Set
    static func set(_ object: AnyObject, forKey key: ObjectDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(object, forKey: key)
    }
    
    // Get
    static func object(forKey key: ObjectDefaultKey) -> Any? {
        let key = namespace(key)
        return UserDefaults.standard.object(forKey: key)
    }
}


// MARK: - Double Defaults
protocol DoubleUserDefaultable: KeyNamespaceable {
    associatedtype DoubleDefaultKey: RawRepresentable
}

extension DoubleUserDefaultable where DoubleDefaultKey.RawValue == String {
    
    // Set
    static func set(_ double: Double, forKey key: DoubleDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(double, forKey: key)
    }
    
    // Get
    static func double(forKey key: DoubleDefaultKey) -> Double {
        let key = namespace(key)
        let value = UserDefaults.standard.double(forKey: key)
        return value
    }
}


// MARK: - URL Defaults
protocol URLUserDefaultable: KeyNamespaceable {
    associatedtype URLDefaultKey: RawRepresentable
}

extension URLUserDefaultable where URLDefaultKey.RawValue == String {
    
    // Set
    static func set(_ url: URL, forKey key: URLDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(url, forKey: key)
    }
    
    // Get
    static func url(forKey key: URLDefaultKey) -> URL? {
        let key = namespace(key)
        let value = UserDefaults.standard.url(forKey: key) ?? URL(string: "")
        return value
    }
}


// MARK: - Use
// Preparation
extension UserDefaults {
    
    

    //Boolean
    struct isSet: BoolUserDefaultable {
        private init() {
        }
        
        enum BoolDefaultKey: String {
            case isConnected
            case isPaid
        }
    }
    
    struct Token: StringUserDefaultable {
        private init() {
        }
        
        enum StringDefaultKey: String {
            case kakaoToken
            case AccessToken
            case UUID
            case FCMToken
        }
    }
    
    struct UserData: StringUserDefaultable {
        private init() {
        }
        
        enum StringDefaultKey: String {
            case Nickname
            case UserEmail
            case KakaoEmail
            case Uid
            case UserToken
            case SPTWalletID
            case SPTAddress
            case PhoneNumber
            case Amount
            case PaidTransferID
            case BitBerryId
        }
    }
    
    struct FreePlay: IntegerUserDefaultable {
        private init() {
            
        }
        
        enum IntegerDefaultKey: String {
            case RemainFreeUse
        }
    }

    
}
