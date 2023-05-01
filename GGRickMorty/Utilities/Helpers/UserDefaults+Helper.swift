//
//  UserDefaults+Helper.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation

class UserDefaultsHelper {

    static let shared = UserDefaultsHelper()
    private let userDefaults = UserDefaults.standard

    // MARK: - Setters
    func setValue(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func setBool(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func setInteger(_ value: Int, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func setDouble(_ value: Double, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func setString(_ value: String?, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    // MARK: - Getters
    func value(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }

    func bool(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    func integer(forKey key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }

    func double(forKey key: String) -> Double {
        return userDefaults.double(forKey: key)
    }

    func string(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }

    // MARK: - Removal
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }

}

struct UserDefaultsKeys {
    static let isUsedByEpisodeViewController = "isUsedByEpisodeViewController"
}
