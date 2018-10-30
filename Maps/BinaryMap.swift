//
//  BinaryMap.swift
//  Maps
//
//  Created by David Gerard on 10/9/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

struct BinaryMap<K: Comparable, V>: CustomStringConvertible {
    var keys = [K]()
    var values = [V]()
    
    mutating func set(_ k: K, v: V) {
        if let index = binarySearch(elements: keys, target: k) { //binary search
            values[index] = v   //found key and reset value
        } else {
            linearInsertion(k, v)   //linear search to input new elements ordered
        }
    }
    
    func get(_ k: K) -> V? {
        if let index = binarySearch(elements: keys, target: k) {
            return values[index]
        }
        return nil
    }
    
    func binarySearch<K: Comparable>(elements: [K], target: K) -> Int? {
        var lowerBound = 0
        var upperBound = elements.count
        
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if elements[midIndex] == target {
                return midIndex
            } else if elements[midIndex] < target {
                lowerBound = midIndex + 1   //+1 b/c already checked for mid index, so don't include it in next range
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
    
    mutating func linearInsertion(_ k: K, _ v: V) {
        for i in 0..<keys.count where k < keys[i] {
            keys.insert(k, at: i)
            values.insert(v, at: i)
            return
        }
        keys.append(k)  //if empty or full map (special case)
        values.append(v)
    }
    
    var count: Int {
        return keys.count
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
            set(index, v: newValue!)
        }
    }
}
