//
//  HashMap.swift
//  Maps
//
//  Created by David Gerard on 10/9/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class HashMap<K: Hashable, V>: AbstractMap<Any, Any> {
    var keys: [K?]
    var values: [V?]
    var linearMap = LinearMap<K, V>()
    let initialArraySize: Int
    var numberCollisions = 0
    
    /*let freshKeys: [K?]()
    let freshValues: [V?]( = [])
    let freshLinearMap = LinearMap<K, V>()
    func setFreshMap() {
        
    }
    func resetToFreshMap() {
        
    }*/
    
    
    init(initialArraySize: Int = 100) {
        self.initialArraySize = initialArraySize
        keys = Array(repeating: nil, count: initialArraySize)
        values = Array(repeating: nil, count: initialArraySize)
    }
    
    func getNumberCollisions() -> Int { return numberCollisions }
    
    func resetCollisions() { numberCollisions = 0 }
    
    var collisionPercent: Double {
        return (Double(getNumberCollisions()) / Double(count)) * 100.0
    }
    
    func set(_ k: K, v: V) {
        let index = getIndex(k)
        if keys[index] == k { //if already present, update value
            values[index] = v
        } else if keys[index] == nil { //if not present + space empty, add entry
            keys[index] = k
            values[index] = v
        } else { //if space occupied, place entry in linear map
            numberCollisions += 1
            linearMap[k] = v
        }
    }
    
    func get(_ k: K) -> V? {
        let index = getIndex(k)
        if keys[index] == k {   //same procedure as set, but different execution
            return values[index]
        } else if keys[index] == nil {
            return nil
        } else {
            numberCollisions += 1
            return linearMap[k]
        }
    }
    
    override var count: Int {return keys.filter({$0 != nil}).count + linearMap.count}
    
    subscript(index: K) -> V? {
        get {
            return get(index)
        } set(newValue) {
            set(index, v: newValue!)
        }
    }
    
    override var description: String {
        var desc = "[\n"
        for i in 0..<keys.count {
            if keys[i] != nil { desc += "\(keys[i]!): \(values[i]!)\n" }
        }
        return desc + "]"
    }
    
    func getIndex(_ k: K) -> Int {
        return abs(k.hashValue % initialArraySize)
    }
}
