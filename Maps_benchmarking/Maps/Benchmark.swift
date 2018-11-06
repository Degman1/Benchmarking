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
    var linearMapGetResults = [Int: Double]()   //[Number of operations: time taken]
    var linearMapSetResults = [Int: Double]()
    var binaryMapGetResults = [Int: Double]()
    var binaryMapSetResults = [Int: Double]()
    var hashMapGetResults = [Int: Double]()
    var hashMapSetResults = [Int: Double]()
    
    //Generic Test Results Storage: To be compared by magnitude to map test results of similar Big-O efficiencies
    var OnResults = [Int: Double]()
    var OlogNResults = [Int: Double]()
    var OcResults = [Int: Double]()
    
    let NUMBER_OPERATIONS = [1, 10, 100, 1000, 10000, 100000]   //keep number contant through all operations to get comparable results
    
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
    
    func doTest_linear() -> Bool {  //Bool represents whether the gets + puts actually matched up -- refer to stulin sample benchmarking code
        return true     //placeholder for now
        //place all results in corresponding dictionaries above
    }
    
    func doTest_binary() -> Bool {
        return true
    }
    
    func doTest_hash() -> Bool {
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
    
}
