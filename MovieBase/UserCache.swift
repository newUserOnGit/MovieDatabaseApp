//
//  UserCache.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//

import Foundation


class UserCache {
    static let shared = UserCache()
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "username"
    private let passwordKey = "password"
    
    func save(userName: String, password: String) {
        userDefaults.set(userName, forKey: userNameKey)
        userDefaults.set(password, forKey: passwordKey)
    }
    
    func getUserName() -> String? {
        return userDefaults.string(forKey: userNameKey)
    }
    
    func getPassword() -> String? {
        return userDefaults.string(forKey: passwordKey)
    }
    
    func compare(userName: String, password: String) -> Bool {
        guard let savedUserName = getUserName(), let savedPassword = getPassword() else {return false}
        return userName == savedUserName && password == savedPassword
    }
}
