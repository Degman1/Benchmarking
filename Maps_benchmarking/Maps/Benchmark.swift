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
    
    //Generic Test Results Storage: To be compared by magnitude to map test results of similar Big-O efficiencies
    var OnResults = [Int: Double]()
    var OlogNResults = [Int: Double]()
    var OcResults = [Int: Double]()
    
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
    
    /*func ratioOf(_ a: Double, outOf: Double) -> Double {
        return (a / outOf) * 100
    }
    
    func compareDataBetweenSets(_ dataset1: [Int: Double], _ dataset2: [Int: Double]) -> [Int: Double] {    //[# Operations : ratio]
        //get the quotient between times for matching n values in data sets.
        //If the quotients are consistent, the efficiency model is accurate.
        //If they vary wildly, the efficiency model is incorrect.
        //for example, if testResults_On[i]/testResults_LinearGet[i] returns
        //[.2, .201, .198, .189, .211], you know that linear get is almost exactly O(.2n), or O(n)
        //if it is [.2, .501, 9.198, 105.00189, 11913.3], linear get is probably not O(n) at all
        if dataset1.count != dataset2.count {
            print("ERROR: MISMATCHING DATASET LENGTH! (dataset1: \(dataset1.count), dataset2: \(dataset2.count))");
            return [0:0]
        }
        var comparison = [Int: Double]();
        for (key, _) in dataset1 {
            comparison[key] = dataset1[key]! / dataset2[key]!;
        }
        return comparison
    }
    
    func dataAnalysis() -> String { //returns information comparing the results of each test that was run
        //include comparisons between map results and comparisons between generic Big-O results
		let analysisLinGet = compareDataBetweenSets(linearMapGetResults, OnResults);
		let analysisLinSet = compareDataBetweenSets(linearMapSetResults, OnResults);

		let analysisBinGet = compareDataBetweenSets(binaryMapGetResults, OlogNResults);
		let analysisBinSetBest = compareDataBetweenSets(binaryMapSetResults, OlogNResults);
		let analysisBinSetWorst = compareDataBetweenSets(binaryMapSetResults, OnResults);

		let analysisHashSetBest = compareDataBetweenSets(hashMapSetResults, OcResults);
		let analysisHashSetWorst = compareDataBetweenSets(hashMapSetResults, OnResults);
		let analysisHashGetBest = compareDataBetweenSets(hashMapGetResults, OcResults);
		let analysisHashGetWorst = compareDataBetweenSets(hashMapGetResults, OnResults);
        
        var output = ""
        output += "Linear Set: \(analysisLinSet)\n"
        output += "Linear Get: \(analysisLinGet)\n"
        output += "Binary Set (Worst Case): \(analysisBinSetWorst)\n"
        output += "Binary Set (Best Case): \(analysisBinSetBest)\n" //if string already exists
        output += "Binary Get: \(analysisBinGet)\n"
        output += "Hash Set (Best Case): \(analysisHashSetBest)\n"
        output += "Hash Set (Worst Case): \(analysisHashSetWorst)\n"
        output += "Hash Get (Best Case): \(analysisHashGetBest)\n"
        output += "Hash Get (Worst Case): \(analysisHashGetWorst)\n"
        
        return output
    }*/
    
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
        //runTest(testWorked: linearTest())
        //runTest(testWorked: binaryTest())
        runTest(testWorked: hashTest())
        /*let _ = hashTest(nOperations: nOperations, size: nOperations / 3)
         print()
         let _ = hashTest(nOperations: nOperations, size: nOperations * 3)
         print()
         let _ = doTest_On(nOperations: nOperations)
         print()
         let _ = doTest_OlogN(nOperations: nOperations)
         print()
         let _ = doTest_Oc(nOperations: nOperations)
         print("\n\n")*/
    }
}

func doBenchmark() {
    let b = Benchmark()
    let _ = b.doTests()
    /*print()
    print(b.statistics)
    print()
    print(b.dataAnalysis())
    */
}
