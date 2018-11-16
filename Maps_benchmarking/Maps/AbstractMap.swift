//
//  AbstractMap.swift
//  Maps
//
//  Created by David Gerard on 10/30/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class AbstractMap<K, V>: CustomStringConvertible {
    func getNumberCollitions() -> Int {return 0}
    func set(_ k: K, v: V) {return}
    func remove(_ k: K) {return}
    func get(_ k: K) -> V? {return nil}
    var count: Int {return 0}
    subscript(index: K) -> V? {return nil}
    var description: String {return "Abstract Map"}
}

protocol Map: CustomStringConvertible {
    associatedtype typeA
    associatedtype typeB
    func getNumberCollitions() -> Int
    func set(_ k: typeA, v: typeB)
    func remove(_ k: typeA)
    func get(_ k: typeA) -> typeB?
    var count: Int {get}
    subscript(index: typeA) -> typeB? {get set}
    var description: String {get}
}
