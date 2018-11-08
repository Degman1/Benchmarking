//
//  LinearMap.swift
//  Maps
//
//  Created by David Gerard on 9/30/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class LinearMap<K: Hashable, V>: AbstractMap<Any, Any> {
    var keys = [K]()
    var values = [V]()
        
    fileprivate func findKeyIndex(_ k: K) -> Int? {
        return keys.index(of: k)
    }
    
    func set(_ k: K, v: V) {
        if let i = findKeyIndex(k) { values[i] = v; return }
        keys.append(k)
        values.append(v)
    }
    
    func get(_ k: K) -> V? {
        if let index = findKeyIndex(k) { return values[index] }
        return nil
    }
    
    override var count: Int  {return keys.count}
        
    override var description: String {
        var desc = "[\n"
        for i in 0..<keys.count { desc += "\(keys[i]): \(values[i])\n" }
        return desc + "]"
    }
    
    subscript(index: K) -> V? {
        get {
            return get(index)
        } set(newValue) {
            set(index, v: newValue!)
        }
    }
}
