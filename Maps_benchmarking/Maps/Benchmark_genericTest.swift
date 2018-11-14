//
//  Benchmark_genericTest.swift
//  Maps
//
//  Created by David Gerard on 11/13/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

//: extension for generic big-O testing:

extension Benchmark {
    
    func doTest_On(nOperations: Int) -> Bool {          // O(n) -- compare to linear map
        let repeats = 200                               //to get average
        var total: Double = 0.0                         //total time taken for all operations
        
        for _ in 0..<repeats {                          //average of the times b/c there is lots of variation
            makeStringList(size: nOperations)
            
            var dummyArray = [String]()
            var dummyArray2 = [String]()                //use 2 arrays to better simulate linearMap
            startTimer()
            for n in 0..<nOperations {
                dummyArray.append(stringList[n])
                dummyArray2.append(stringList[n])
            }
            endTimer()
            total += elapsedTimems()
        }
        benchmarkMessageMillis(operationName: "Dummy O(n) average (\(nOperations) operations)", time: elapsedTimems())
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
        benchmarkMessageMillis(operationName: "Dummy O(logn) (\(nOperations) operations)", time: elapsedTimems())
        OlogNResults[nOperations] = elapsedTimems()   //place all results in corresponding dictionaries
        return true
    }
    
    func doTest_Oc(nOperations: Int) -> Bool {          // O(c) -- compare to hash map
        makeStringList(size: nOperations)
        
        var dummyArray = [String]()
        
        startTimer()
        for n in 0..<nOperations {    //or any other value, 10000 chosen just because it's big
            dummyArray.append(stringList[n])
        }
        endTimer()
        benchmarkMessageMillis(operationName: "Dummy O(c) (\(nOperations) operations)", time: elapsedTimems())
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
}
