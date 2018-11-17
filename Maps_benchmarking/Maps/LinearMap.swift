//
//  LinearMap.swift
//  Maps
//
//  Created by David Gerard on 9/30/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class LinearMap<K: Hashable, V>: AbstractMap<K, V> {
    var keys = [K]()
    var values = [V]()
    
    init() {
        super.init(type: .linear)
    }
    
    func setContents(keys: [K], values: [V]) {
        self.keys = keys
        self.values = values
    }
    
    override func getKeys() -> [K] {
        return keys
    }
    
    fileprivate func findKeyIndex(_ k: K) -> Int? {
        //return keys.index(of: k)  //do this instead of .index(of:) to know exactly whats happening (big-O wise):
        for i in 0..<keys.count { if keys[i] == k {return i} }
        return nil
    }
    
    override func set(_ k: K, v: V) {
        if let i = findKeyIndex(k) { values[i] = v; return }
        keys.append(k)
        values.append(v)
    }
    
    override func get(_ k: K) -> V? {
        if let index = findKeyIndex(k) { return values[index] }
        return nil
    }
    
    override var count: Int  {return keys.count}
        
    override var description: String {
        var desc = "[\n"
        for i in 0..<keys.count { desc += "\(keys[i]): \(values[i])\n" }
        return desc + "]"
    }
    
    override subscript(index: K) -> V? {
        get {
            return get(index)
        } set(newValue) {
            set(index, v: newValue!)
        }
    }
}
