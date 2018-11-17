//
//  MapTest.swift
//  Maps
//
//  Created by David Gerard on 11/6/18.
//  Copyright © 2018 David Gerard. All rights reserved.
//

import Foundation

class Benchmark_polymorphism {
    
    let TOTAL_OPERATIONS = 100   //keep number contant through all operations to get comparable results
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
    
    func performTest( map: inout AbstractMap<String, String>, arraySize: Int ) -> [Double] {
        makeStringList(size: arraySize)                   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        for n in 0..<(arraySize - 1) {                    //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArray = map.getKeys()                           //use to refresh keys and values in map each operation
        let freshOverflowArray = map.getOverflowKeys()
        
        let addValue = stringList[arraySize - 1]          //last value left to add to map
        let setCollisionCount = map.getNumberCollitions()
        
        for _ in 0..<TOTAL_OPERATIONS {
            if map.type == .hash {
                map.setContents(keys: freshArray, values: freshArray, lKeys: freshOverflowArray, lValues: freshOverflowArray)  //run at start to leave map full at end of loop
            } else {
                map.setContents(keys: freshArray, values: freshArray)
            }
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
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
        
        return [set, time / Double(TOTAL_OPERATIONS), Double(setCollisionCount), Double(map.getNumberCollitions() - setCollisionCount)]
    }
    
    func runTest(type: MapType, testMode: Bool = false, betterCase: Bool = true) -> Bool {
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
            
            print("\(betterCase ? "Better" : "Worse") Case:")
            var result = performTest(map: &emptyMap, arraySize: size)
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
        let isTestRun = true
        runCheckTest(testWorked: runTest(type: .linear, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .binary, testMode: isTestRun))
        print("\n\n")
        runCheckTest(testWorked: runTest(type: .hash, testMode: isTestRun))
    }
}

func doBenchmark_poly() {
    let b = Benchmark_polymorphism()
    let _ = b.runAllTests()
}













//STULIN'S ORIGINAL MAP TESTING CODE

public class MapTest {
    var stringList = [String]()
    let chars = Array("abcdefghijklmnopqrstuvwxyz")
    
    let MAX_SIZE = 1000
    let NUMBER_PUTS = 1000
    func getRandomInt(range: Int)->Int{
        return Int(arc4random_uniform(UInt32(range)) )
    }
    func makeString(length: Int)->String{
        var s = ""
        let numberChars = chars.count
        for _ in 0..<length {
            s.append(chars[getRandomInt(range: numberChars)])
            
        }
        return s;
    }
    func makeStringList(size: Int) {
        stringList = [String]()
        for _ in 0..<size {
            stringList.append(makeString(length: 10))
        }
    }
    func testLinearMap()->Bool{
        var value = ""
        var key = ""
        let map = LinearMap<String, String>()
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], v: stringList[i]);
        }
        
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)){
                return false;
            }
        }
        return true;
    }
    func testBinaryMap()->Bool{
        var value = ""
        var key = ""
        let map = BinaryMap<String, String>()
        for i in 0..<NUMBER_PUTS{
            map.set(stringList[i], v: stringList[i]);
        }
        
        
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)) {
                return false;
            }
            
        }
        return true;
        
        
    }
    func testHashMap()-> Bool {
        var value = ""
        var key = ""
        let map = HashMap<String, String>(initialArraySize: 2000)
        for i in 0..<NUMBER_PUTS {
            map.set(stringList[i], v: stringList[i]);
        }
        for index in 0..<NUMBER_PUTS {
            key = stringList[index]
            value = map.get(key)!
            if (!(value == key)) {
                return false;
            }
        }
        print("Collisions: \(map.getNumberCollisions())")
        return true;
    }
    func doTest(){
        makeStringList(size: MAX_SIZE)
        print("String List Complete")
        print("Linear: \(testLinearMap())")
        print("Binary: \(testBinaryMap())")
        print("Hash: \(testHashMap())")
        
    }
}
