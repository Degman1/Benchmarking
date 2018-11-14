//
//  Benchmark_mapTest.swift
//  Maps
//
//  Created by David Gerard on 11/13/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

//: extension for map testing

extension Benchmark {
    func doLinearTest(nOperations: Int) -> [Double] { //return time taken
        makeStringList(size: MAX_ARRAY_SIZE)                   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = LinearMap<String, String>()
        for n in 0..<(MAX_ARRAY_SIZE - 1) {                    //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArray = map.keys                           //use to refresh keys and values in map each operation
        let addValue = stringList[MAX_ARRAY_SIZE - 1]          //last value left to add to map
        
        for _ in 0..<nOperations {
            map.keys = freshArray; map.values = freshArray  //run at start to leave map full at end of looop
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        //benchmarkMessageMillis(operationName: "Linear Map Set (\(nOperations) operations)", time: time)
        //linearMapSetResults[nOperations] = time / Double(nOperations)      //place all results in dictionaries
        let set = time / Double(nOperations)
        
        time = 0.0                                          //reset time
        for _ in 0..<nOperations {
            index = getRandomInt(range: MAX_ARRAY_SIZE)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad linear map... uh oh"); return [0] }   //something went wrong with map
        }
        
        //benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)", time: time)
        //linearMapGetResults[nOperations] = time / Double(nOperations) //gives the time per operation
        return [set, time / Double(nOperations)]
    }
    
    func linearTest(nOperations: Int) -> Bool {             //bool represents if map works
        var total_set = 0.0
        var total_get = 0.0
        let a = 10  //TODO: make larger for real test for accuracy
        
        for _ in 0..<a {
            let result = doLinearTest(nOperations: nOperations)
            if result[0] == 0 {return false}
            total_set += result[0]
            total_get += result[1]
        }
        
        benchmarkMessageMillis(operationName: "Linear Map Set (\(nOperations) operations)", time: total_set / Double(a))
        benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)", time: total_get / Double(a))
        linearMapSetResults[nOperations] = total_set / Double(a)
        linearMapGetResults[nOperations] = total_get / Double(a)
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
