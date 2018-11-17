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
    var linearMapGetResults = [Int: Double]()   //[Number of operations: time taken (milliseconds)]
    var linearMapSetResults = [Int: Double]()
    var binaryMapGetResults = [Int: Double]()
    var binaryMapSetResults = [Int: Double]()
    var hashMapGetResults = [Int: Double]()
    var hashMapSetResults = [Int: Double]()
    
    let TOTAL_OPERATIONS = 100   //keep number contant through all operations to get comparable results
    let ARRAY_SIZES = [1000, 5000, 10000, 50000, 100000]   //change to see how array size changes the timing
    let ARRAY_SIZES_TEST = [100, 500, 1000, 5000]   //smaller #'s to run it faster when testing
    
    //keep track of timer:
    var startTaskms: Double = 0	//I wanted to make this Float80 but vscode didn't highlight it as a valid type
    var endTaskms: Double = 0	//double is 64 bit so it should still suffice
    
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
    
    var statistics: String {
        var desc = "\nBenchmark Test Results:\n"
        desc += "\tLinear Set Test Results - \(linearMapSetResults)\n"
        desc += "\tLinear Get Test Results - \(linearMapGetResults)\n"
        desc += "\tBinary Set Test Results - \(binaryMapSetResults)\n"
        desc += "\tBinary Get Test Results - \(binaryMapGetResults)\n"
        desc += "\tHash Set Test Results - \(hashMapSetResults)\n"
        desc += "\tHash Get Test Results - \(linearMapGetResults)"
        return desc
    }
    
    func runTest(testWorked: Bool) {
        if testWorked { print("maps and testing successful!\n") }
        else { print("maps and testing failed\n") }
    }
    
    func doTests() {
        runTest(testWorked: linearTest())
        runTest(testWorked: binaryTest())
        runTest(testWorked: hashTest())
    }
}

func doBenchmark() {
    let b = Benchmark()
    let _ = b.doTests()
}
