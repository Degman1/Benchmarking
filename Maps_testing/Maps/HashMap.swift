//
//  HashMap.swift
//  Maps
//
//  Created by David Gerard on 10/9/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

struct HashMap<K: Hashable, V>: CustomStringConvertible {
    var keys: [K?]
    var values: [V?]
    var linearMap = LinearMap<K, V>()
    let initialArraySize: Int
    var count = 0
    var numberCollisions = 0
    
    init(initialArraySize: Int = 100) {
        self.initialArraySize = initialArraySize
        keys = Array(repeating: nil, count: initialArraySize)
        values = Array(repeating: nil, count: initialArraySize)
    }
    
    func getIndex(_ k: K) -> Int {
        return abs(k.hashValue % initialArraySize)
    }
    
    func getNumberCollisions() -> Int { return numberCollisions }
    
    mutating func set(_ k: K, _ v: V) {
        let index = getIndex(k)
        if keys[index] == k { //if already present, update value
            values[index] = v
        } else if keys[index] == nil { //if not present + space empty, add entry
            keys[index] = k
            values[index] = v
            count += 1
        } else { //if space occupied by other, place new entry in linear map
            numberCollisions += 1
            linearMap[k] = v
            count += 1
        }
    }
    
    func get(_ k: K) -> V? {
        let index = getIndex(k)
        if keys[index] == k {   //same procedure as set, but different execution
            return values[index]
        } else if keys[index] == nil {
            return nil
        } else {
            return linearMap[k]
        }
    }
    
    var description: String {
        var desc = "[\n"
        for i in 0..<keys.count {
            if keys[i] != nil { desc += "\(keys[i]!): \(values[i]!)\n" }
        }
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
