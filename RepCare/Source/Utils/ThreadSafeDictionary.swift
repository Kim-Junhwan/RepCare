//
//  ThreadSafeDictionary.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/08.
//

import Foundation

class ThreadSafeDictionary<T: Hashable, V>: Collection {
    
    private var dictionary: [T: V]
    private let dispatchQueue = DispatchQueue(label: "Thread Safe Dictionary", attributes: .concurrent)
    
    var keys: Dictionary<T, V>.Keys {
        self.dispatchQueue.sync {
            return self.dictionary.keys
        }
    }
    
    var values: Dictionary<T, V>.Values {
        self.dispatchQueue.sync {
            return self.dictionary.values
        }
    }
    
    var startIndex: Dictionary<T, V>.Index {
        self.dispatchQueue.sync {
            return self.dictionary.startIndex
        }
    }
    
    var endIndex: Dictionary<T, V>.Index {
        self.dispatchQueue.sync {
            return self.dictionary.endIndex
        }
    }
    
    init(dictionary: [T:V] = [T:V]()) {
        self.dictionary = dictionary
    }
    
    subscript(key: T) -> V? {
        get {
            self.dispatchQueue.sync {
                return self.dictionary[key]
            }
        }
        
        set {
            self.dispatchQueue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
    
    subscript(position: Dictionary<T, V>.Index) -> V? {
        get {
            self.dispatchQueue.sync {
                return self.dictionary[position].value
            }
        }
    }
    
    func index(after i: Dictionary<T, V>.Index) -> Dictionary<T, V>.Index {
        self.dispatchQueue.sync {
            return self.dictionary.endIndex
        }
    }
    
    func removeValue(forKey key: T) {
        self.dispatchQueue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
}
