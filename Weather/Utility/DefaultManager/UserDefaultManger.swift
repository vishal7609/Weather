//
//  UserDefaultManger.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation

enum UserDefaultKey: String {
    case cityDataSave = "CityDataSave"
}

class UserDefaultManger {
    private init() {}
    static let shared = UserDefaultManger()
    private let manager =  UserDefaults.standard

    ///  to set /update key value pair in user default
    /// - Parameter value: any primitive type  will be accepted like int, bool , float.
    /// - Parameter key: to uniquely identify element in user defaults a string key is required
    func set(_ value: Any?, forKey key: UserDefaultKey) {
        manager.set(value, forKey: key.rawValue)
        manager.synchronize()
    }

    /// get object for the particular key
    /// - Parameter key: string to identify that object
    func object(forKey key: UserDefaultKey) -> Any? {
        return manager.object(forKey: key.rawValue)
    }

    /// remove object for the particular key
    /// - Parameter key: string to identify that object
    func removeObject(forKey key: UserDefaultKey) {
        manager.removeObject(forKey: key.rawValue)
    }
}
