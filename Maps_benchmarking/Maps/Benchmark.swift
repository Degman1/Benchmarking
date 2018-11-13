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
    
    let NUMBER_OPERATIONS = [100, 500, 1000, 5000, 10000]   //keep number contant through all operations to get comparable results
    
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
    
    func ratioOf(_ a: Double, outOf: Double) -> Double {
        return (a / outOf) * 100
    }
    
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
        
        for _ in 0..<nOperations {
            map.keys = freshArray; map.values = freshArray  //run at start so in end the last key + value is left in map for the get
            startTimer()
            map.set(stringList[nOperations - 1], v: stringList[nOperations - 1])
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
            time += getCurrentMillis()
            if !(value == key) { print("bad linear map... uh oh"); return false }
        }
        
        benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)", time: time)
        linearMapGetResults[nOperations] = elapsedTimems() / Double(nOperations) //gives the time per operation
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
        benchmarkMessageMillis(operationName: "Binary Map Set (\(nOperations) operations)", time: getCurrentMillis())
        binaryMapSetResults[nOperations] = elapsedTimems() / Double(nOperations)
        
        startTimer()
        for _ in 0..<nOperations {
            index = getRandomInt(range: nOperations)
            key = stringList[index]
            value = map.get(key)!
            if !(value == key) { print("bad hash map... uh oh"); return false }
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Binary Map Get (\(nOperations) operations)", time: getCurrentMillis())
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
        
        benchmarkMessageMillis(operationName: "Hash Map Get (\(nOperations) operations, \(map.getNumberCollisions()) collisions, \(p)% collision rate)", time: getCurrentMillis())
        hashMapGetResults[nOperations] = elapsedTimems() / Double(nOperations)
        return true
    }
    
    func doTest_On(nOperations: Int) -> Bool {          // O(n) -- compare to linear map
        let repeats = 200   //to get average
        var total: Double = 0.0
        for _ in 0..<repeats {  //gets average of the values b/c they seem to be able to vary a lot every now and then
            makeStringList(size: nOperations)
            
            var dummyArray = [String]()
            var dummyArray2 = [String]()
            startTimer()
            for n in 0..<nOperations {
                dummyArray.append(stringList[n])
                dummyArray2.append(stringList[n])
            }
            endTimer()
            total += elapsedTimems()
        }
        benchmarkMessageMillis(operationName: "Dummy O(n) average (\(nOperations) operations)", time: getCurrentMillis())
        OnResults[nOperations] = total / Double(repeats)
        return true
    }
    
    func doTest_OlogN(nOperations: Int) -> Bool {       // O(log(n)) -- compare to binary map
        makeStringList(size: nOperations)

		var dummyArray = [String]()
        
        startTimer()
        for n in 0..<Int(log2(Double(nOperations))) {
            dummyArray.append(stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Dummy O(logn) (\(nOperations) operations)", time: getCurrentMillis())
        OlogNResults[nOperations] = elapsedTimems()   //place all results in corresponding dictionaries
        return true
    }
    
    func doTest_Oc(nOperations: Int) -> Bool {          // O(c) -- compare to hash map
        makeStringList(size: nOperations)

		var dummyArray = [String]()
        
        startTimer()
        for n in 0..<nOperations {	//or any other value, 10000 chosen just because it's big
            dummyArray.append(stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Dummy O(c) (\(nOperations) operations)", time: getCurrentMillis())
        OcResults[nOperations] = elapsedTimems()   //place all results in corresponding dictionaries
        return true
    }
    
    func doTests() {
        for nOperations in NUMBER_OPERATIONS {
            print("Running tests with \(nOperations) operations:")
            let _ = linearTest(nOperations: nOperations)
            print()
            let _ = binaryTest(nOperations: nOperations)
            print()
            let _ = hashTest(nOperations: nOperations, size: nOperations / 3)
            print()
            let _ = hashTest(nOperations: nOperations, size: nOperations * 3)
            print()
			let _ = doTest_On(nOperations: nOperations)
            print()
			let _ = doTest_OlogN(nOperations: nOperations)
            print()
			let _ = doTest_Oc(nOperations: nOperations)
            print("\n\n")
        }
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
            return [1:1]
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
        output += "Linear Get: \(analysisLinGet)\n"
        output += "Linear Set: \(analysisLinSet)\n"
        output += "Binary Get: \(analysisBinGet)\n"
        output += "Binary Set (Worst Case): \(analysisBinSetWorst)\n"
        output += "Binary Set (Best Case): \(analysisBinSetBest)\n" //if string already exists
        output += "Hash Set (Best Case): \(analysisHashSetBest)\n"
        output += "Hash Set (Worst Case): \(analysisHashSetWorst)\n"
        output += "Hash Get (Best Case): \(analysisHashGetBest)\n"
        output += "Hash Get (Worst Case): \(analysisHashGetWorst)\n"
        
        return output
    }
    
    func statistics() {
        print("\nBenchmark Test Results:")
        print("\tLinear Set Test Results - \(linearMapSetResults)")
        print("\tLinear Get Test Results - \(linearMapGetResults)")
        print("\tBinary Set Test Results - \(binaryMapSetResults)")
        print("\tBinary Get Test Results - \(binaryMapGetResults)")
        print("\tHash Set Test Results - \(hashMapSetResults)")
        print("\tHash Get Test Results - \(linearMapGetResults)")
    }
}

func doBenchmark() {
    let b = Benchmark()
    let _ = b.doTests()
    print()
    print(b.statistics())
    print()
    print(b.dataAnalysis())
    
}
