//
//  Benchmark_mapTest.swift
//  Maps
//
//  Created by David Gerard on 11/13/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

//extension for map testing
extension Benchmark {
    func linearTest(nOperations: Int) -> Bool {  //Bool represents whether the gets + puts actually matched up (checks to make sure maps code ran successfully) -- refer to stulin sample benchmarking code
        makeStringList(size: nOperations)   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = LinearMap<String, String>()
        for n in 0..<(nOperations - 1) {    //preset the map so that the # of entries already present through each operation stays constant - leave 1 left though to use to for the set
            map.set(stringList[n], v: stringList[n])
        }
        let freshArray = map.keys   //use to refresh keys and values in map each operation
        let addValue = stringList[nOperations - 1]
        
        for _ in 0..<nOperations {
            map.keys = freshArray; map.values = freshArray  //run at start so in end the last key + value is left in map for the get
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        benchmarkMessageMillis(operationName: "Linear Map Set (\(nOperations) operations)", time: time)
        linearMapSetResults[nOperations] = time / Double(nOperations)   //place all results in corresponding dictionaries
        
        time = 0.0
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad linear map... uh oh"); return false }
        }
        
        benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)", time: time)
        linearMapGetResults[nOperations] = elapsedTimems() //gives the time per operation
        return true
    }
    
    func binaryTest(nOperations: Int) -> Bool {
        makeStringList(size: nOperations)
        var key = ""
        var value = ""
        var index = 0
        
        let map = BinaryMap<String, String>()
        
        startTimer()
        for n in 0..<nOperations {
            map.set(stringList[n], v: stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Set (\(nOperations) operations)", time: elapsedTimems())
        binaryMapSetResults[nOperations] = elapsedTimems() / Double(nOperations)
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad hash map... uh oh"); return false }
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Get (\(nOperations) operations)", time: elapsedTimems())
        binaryMapGetResults[nOperations] = elapsedTimems() / Double(nOperations)
        return true
    }
    
    func hashTest(nOperations: Int, size: Int) -> Bool {
        makeStringList(size: nOperations)
        var key = ""
        var value = ""
        var index = 0
        
        let map = HashMap<String, String>(initialArraySize: size)
        
        startTimer()
        for n in 0..<nOperations {
            map.set(stringList[n], v: stringList[n])
        }
        endTimer()
        let p = ratioOf(Double(map.getNumberCollisions()), outOf: Double(nOperations))
        benchmarkMessageMillis(operationName: "Hash Map Set (\(nOperations) operations, \(map.getNumberCollisions()) collisions, \(p)% collision rate)", time: getCurrentMillis())
        hashMapSetResults[nOperations] = elapsedTimems() / Double(nOperations)
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad hash map... uh oh"); return false }
        }
        endTimer()
        
        benchmarkMessageMillis(operationName: "Hash Map Get (\(nOperations) operations, \(map.getNumberCollisions()) collisions, \(p)% collision rate)", time: elapsedTimems())
        hashMapGetResults[nOperations] = elapsedTimems() / Double(nOperations)
        return true
    }
}
