//
//  Benchmark.swift
//  Maps
//
//  Created by David Gerard on 11/5/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class Benchmark {
    //Map Test Results Storage:
    var linearMapGetResults = [Int: Int]()   //[Number of operations: time taken (tenths of seconds)]
    var linearMapSetResults = [Int: Int]()
    var binaryMapGetResults = [Int: Int]()
    var binaryMapSetResults = [Int: Int]()
    var hashMapGetResults = [Int: Int]()
    var hashMapSetResults = [Int: Int]()
    
    //Generic Test Results Storage: To be compared by magnitude to map test results of similar Big-O efficiencies
    var OnResults = [Int: Int]()
    var OlogNResults = [Int: Int]()
    var OcResults = [Int: Int]()
    
    let NUMBER_OPERATIONS = [10000, 20000, 30000, 40000, 50000]   //keep number contant through all operations to get comparable results
    
    //keep track of timer:
    var startTaskms: Int64 = 0
    var endTastms: Int64 = 0
    
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
    
    func getCurrentMillis() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func startTimer() {
        startTaskms = getCurrentMillis()
    }
    
    func endTimer() {
        endTastms = getCurrentMillis()
    }
    
    func elapsedTimems() -> Int {
        return Int(endTastms - startTaskms)
    }
    
    func elapsedTimeSeconds() -> Int {
        return elapsedTimems() / 1000
    }
    
    func elapsedTimeTenthsSeconds() -> Int {
        return elapsedTimems() / 1000
    }
    
    func benchmarkMessageTenths(operationName: String) {
        print("\(operationName) took \(elapsedTimeTenthsSeconds()) tenths of a second")
    }
    
    func benchmarkMessageMillis(operationName: String) {
        print("\(operationName) took \(elapsedTimems()) ms")

    }
    
    func linearTest(nOperations: Int) -> Bool {  //Bool represents whether the gets + puts actually matched up (checks to make sure maps code ran successfully) -- refer to stulin sample benchmarking code
        makeStringList(size: nOperations)   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        
        let map = LinearMap<String, String>()
        
        startTimer()
        for n in 0..<nOperations {
            map.set(stringList[n], v: stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Linear Map Set (\(nOperations) operations)")
        linearMapSetResults[nOperations] = elapsedTimeTenthsSeconds()   //place all results in corresponding dictionaries
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad linear map... uh oh"); return false }
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)")
        linearMapGetResults[nOperations] = elapsedTimeTenthsSeconds()
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
        benchmarkMessageMillis(operationName: "Binary Map Set (\(nOperations) operations)")
        binaryMapSetResults[nOperations] = elapsedTimeTenthsSeconds()
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad hash map... uh oh"); return false }
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Get (\(nOperations) operations)")
        binaryMapGetResults[nOperations] = elapsedTimeTenthsSeconds()
        return true
    }
    
    func hashTest(nOperations: Int) -> Bool {
        makeStringList(size: nOperations)
        var key = ""
        var value = ""
        var index = 0
        
        let map = HashMap<String, String>()
        
        startTimer()
        for n in 0..<nOperations {
            map.set(stringList[n], v: stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Set (\(nOperations) operations)")
        binaryMapSetResults[nOperations] = elapsedTimeTenthsSeconds()
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad hash map... uh oh"); return false }
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Get (\(nOperations) operations)")
        binaryMapGetResults[nOperations] = elapsedTimeTenthsSeconds()
        return true
    }
    
    func doTest_On() -> Bool {          // O(n) -- compare to linear map
        return true
    }
    
    func doTest_OlogN() -> Bool {       // O(log(n)) -- compare to binary map
        return true
    }
    
    func doTest_Oc() -> Bool {          // O(c) -- compare to hash map
        return true
    }
    
    func doTests() {
        for nOperations in NUMBER_OPERATIONS {
            let _ = linearTest(nOperations: nOperations)
            let _ = binaryTest(nOperations: nOperations)
            let _ = hashTest(nOperations: nOperations)
        }
    }
    
    func compareDataBetweenSets(dataset1: [(Int, Double)], dataset2: [(Int, Double)]) {
        //get the quotient between times for matching n values in data sets.
        //If the quotients are consistent, the efficiency model is accurate.
        //If they vary wildly, the efficiency model is incorrect.
        //for example, if testResults_On[i]/testResults_LinearGet[i] returns
        //[.2, .201, .198, .189, .211], you know that linear get is almost exactly O(.2n), or O(n)
        //if it is [.2, .501, 9.198, 105.00189, 11913.3], linear get is probably not O(n) at all
    }
    
    func dataAnalysis() -> String { //returns information comparing the results of each test that was run
        //include comparisons between map results and comparisons between generic Big-O results
        return ""
    }
}


func doBenchmark() {
    let b = Benchmark()
    let _ = b.linearTest(nOperations: 20000)
    print()
    let _ = b.binaryTest(nOperations: 20000)
    print()
    let _ = b.hashTest(nOperations: 20000)
}
