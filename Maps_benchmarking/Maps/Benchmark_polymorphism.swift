//
//  Benchmark_polymorphism.swift
//  Maps
//
//  Created by David Gerard on 11/16/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class Benchmark_polymorphism {
    
    let TOTAL_OPERATIONS = 100   //keep number contant through all operations to get comparable results -- gets average
    let ARRAY_SIZES = [1000, 5000, 10000, 50000, 100000]   //change to see how array size changes the timing
    let ARRAY_SIZES_TEST = [100, 500, 1000, 5000]   //smaller #'s to run it faster when testing
    
    //keep track of timer:
    var startTaskms: Double = 0    //I wanted to make this Float80 but vscode didn't highlight it as a valid type
    var endTaskms: Double = 0    //double is 64 bit so it should still suffice
    
    var stringList = [String]()     //stores set of random strings to use when setting + getting values from maps
    let chars = Array("abcdefghijklmnopqrstuv")
    
    
    func makeString(length: Int) -> String {
        var s = ""
        let numberChars = chars.count
        for _ in 0..<length {
            s.append(chars[getRandomInt(range: numberChars)])
        }
        return s
    }
    
    func makeStringList(size: Int) {
        stringList = [String]()
        for _ in 0..<size {
            stringList.append(makeString(length: 5))
        }
    }
    
    func getRandomInt(range: Int) -> Int {
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    func getCurrentMillis() -> Double {
        return Double(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func startTimer() {
        startTaskms = getCurrentMillis()
    }
    
    func endTimer() {
        endTaskms = getCurrentMillis()
    }
    
    func elapsedTimems() -> Double {
        return Double(endTaskms - startTaskms)
    }
    
    func elapsedTimeSeconds() -> Int {
        return Int(elapsedTimems() / 1000)
    }
    
    func elapsedTimeTenthsSeconds() -> Int {
        return Int(elapsedTimems() / 100)
    }
    
    func benchmarkMessageMillis(operationName: String, time: Double) {
        print("\(operationName) took \(time) ms")
    }
    
    func performTest( map: inout AbstractMap<String, String>, arraySize: Int, operationType: SetOperationType ) -> [Double] {
        makeStringList(size: arraySize)                   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        for n in 0..<( (operationType == .SetNewValue) ? arraySize - 1 : arraySize ) {      //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArray = map.allKeys()!     //use to refresh keys and values in map each operation     //use to refresh keys and values in map each operation
        
        let addValue = stringList[arraySize - 1]          //last value left to add to map
        let setCollisionCount = map.getNumberCollisions()
        
        /*map.bestCaseCount = 0
        map.worstCaseCount = 0
        var isThereCount = 0*/
        
        for _ in 0..<TOTAL_OPERATIONS {
            map.setMany(keys: freshArray, values: freshArray)
            //isThereCount += (map.get(addValue) == addValue) ? 1 : 0
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        /*print("\tbest case: \(map.bestCaseCount)")
        print("\tworse case: \(map.worstCaseCount)")
        print("\tKey was present \(isThereCount) times.")*/
        
        let set = time / Double(TOTAL_OPERATIONS)
        
        time = 0.0                                          //reset time
        for _ in 0..<TOTAL_OPERATIONS {
            index = getRandomInt(range: arraySize)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad \(map.type) map... uh oh"); return [0] }   //something went wrong with map
        }
        
        return [set, time / Double(TOTAL_OPERATIONS), Double(setCollisionCount), Double(map.getNumberCollisions() - setCollisionCount)]
    }
    
    func runTest(type: MapType, operation: SetOperationType, testMode: Bool = false, betterCase: Bool = true) -> Bool {
        var emptyMap: AbstractMap<String, String>
        let sizes = testMode ? ARRAY_SIZES_TEST : ARRAY_SIZES
        
        for size in sizes {
            print("Running \(type) tests for size \(size):")
            
            switch type {
            case .linear: emptyMap = LinearMap<String, String>()
            case .binary: emptyMap = BinaryMap<String, String>()
            case .hash: emptyMap = HashMap<String, String>(initialArraySize: betterCase ? (size * 5) : (size / 5))
            case .abstract: return false
            }
            
            print("\(operation):")
            var result = performTest(map: &emptyMap, arraySize: size, operationType: operation)
            if result[0] == 0 {return false}
            
            benchmarkMessageMillis(operationName: "\(type) Map Set (\(size) size, \(result[2]) collisions)", time: result[0])
            benchmarkMessageMillis(operationName: "\(type) Map Get (\(size) size, \(result[3]) collisions)", time: result[1])
            print()
        }
        
        return true
    }
    
    func runCheckTest(testWorked: Bool) {
        if testWorked { print("maps and testing successful!\n") }
        else { print("maps and testing failed\n") }
    }
    
    func runAllTests() {
        let isTestRun = false
        runCheckTest(testWorked: runTest(type: .linear, operation: .SetNewValue, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .linear, operation: .UpdateValue, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .binary, operation: .SetNewValue, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .binary, operation: .UpdateValue, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .hash, operation: .SetNewValue, testMode: isTestRun, betterCase: true))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .hash, operation: .UpdateValue, testMode: isTestRun, betterCase: true))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .hash, operation: .SetNewValue, testMode: isTestRun, betterCase: false))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .hash, operation: .UpdateValue, testMode: isTestRun, betterCase: false))
    }
}

enum SetOperationType {
    case SetNewValue, UpdateValue, BetterHash, WorseHash
}

func doBenchmark_poly() {
    let b = Benchmark_polymorphism()
    let _ = b.runAllTests()
}
