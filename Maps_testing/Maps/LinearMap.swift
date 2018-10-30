//
//  LinearMap.swift
//  Maps
//
//  Created by David Gerard on 9/30/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

struct LinearMap<K: Hashable, V>: CustomStringConvertible {
    var keys = [K]()
    var values = [V]()
    var count: Int = 0
    
    fileprivate func findKeyIndex(_ k: K) -> Int? {
        return keys.index(of: k)
    }
    
    mutating func set(_ k: K, _ v: V) {
        if let i = findKeyIndex(k) { values[i] = v; return }
        keys.append(k)
        values.append(v)
        count += 1
    }
    
    func get(_ k: K) -> V? {
        if let index = findKeyIndex(k) { return values[index] }
        return nil
    }
    
    var description: String {
        var desc = "[\n"
        for i in 0..<keys.count { desc += "\(keys[i]): \(values[i])\n" }
        return desc + "]"
    }
    
    subscript(index: K) -> V? {
        get {
            return get(index)
        } set(newValue) {
            set(index, newValue!)
        }
    }
}
