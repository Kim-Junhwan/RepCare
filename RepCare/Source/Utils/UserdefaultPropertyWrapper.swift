//
//  UserdefaultPropertyWrapper.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/03/28.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}
