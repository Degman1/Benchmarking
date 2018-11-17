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
    func doLinearTest(size: Int) -> [Double] { //return time taken
        makeStringList(size: size)                   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = LinearMap<String, String>()
        for n in 0..<(size - 1) {                    //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArray = map.keys                           //use to refresh keys and values in map each operation
        let addValue = stringList[size - 1]          //last value left to add to map
        
        for _ in 0..<TOTAL_OPERATIONS {
            map.keys = freshArray; map.values = freshArray  //run at start to leave map full at end of loop
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        //benchmarkMessageMillis(operationName: "Linear Map Set (\(nOperations) operations)", time: time)
        //linearMapSetResults[nOperations] = time / Double(nOperations)      //place all results in dictionaries
        let set = time / Double(TOTAL_OPERATIONS)
        
        time = 0.0                                          //reset time
        for _ in 0..<TOTAL_OPERATIONS {
            index = getRandomInt(range: size)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad linear map... uh oh"); return [0] }   //something went wrong with map
        }
        
        //benchmarkMessageMillis(operationName: "Linear Map Get (\(nOperations) operations)", time: time)
        //linearMapGetResults[nOperations] = time / Double(nOperations) //gives the time per operation
        return [set, time / Double(TOTAL_OPERATIONS)]
    }
    
    func linearTest() -> Bool {             //bool represents if map works
        for size in ARRAY_SIZES {
            print("\nRunning linear tests:")
            let result = doLinearTest(size: size)
            if result[0] == 0 {return false}
            
            benchmarkMessageMillis(operationName: "Linear Map Set (length of \(size))", time: result[0])
            benchmarkMessageMillis(operationName: "Linear Map Get (length of \(size))", time: result[1])
            linearMapSetResults[size] = result[0]
            linearMapGetResults[size] = result[1]
            print()
        }
        
        return true
    }
    
	func doBinaryTest(size: Int) -> [Double] { //return time taken
        makeStringList(size: size)                   //to put in maps -- later use to get out of maps
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = BinaryMap<String, String>()
        
        for n in 0..<(size - 1) {                    //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArray = map.keys                           //use to refresh keys and values in map each operation
        let addValue = stringList[size - 1]          //last value left to add to map
        
        for _ in 0..<TOTAL_OPERATIONS {
            map.keys = freshArray; map.values = freshArray  //run at start to leave map full at end of looop
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        let set = time / Double(TOTAL_OPERATIONS)
        
        time = 0.0                                          //reset time
        for _ in 0..<TOTAL_OPERATIONS {
            index = getRandomInt(range: size)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad binary map... uh oh"); return [0] }   //something went wrong with map
        }
		//returns [set, get]
        return [set, time / Double(TOTAL_OPERATIONS)]
    }

	func binaryTest() -> Bool {             //bool represents if map works
        for size in ARRAY_SIZES {
            print("\nRunning binary tests:")
            let result = doBinaryTest(size: size)
            if result[0] == 0 {return false}
            
            benchmarkMessageMillis(operationName: "Binary Map Set (length of \(size))", time: result[0])
            benchmarkMessageMillis(operationName: "Binary Map Get (length of \(size))", time: result[1])
            binaryMapSetResults[size] = result[0]
            binaryMapGetResults[size] = result[1]
            print()
        }
        return true
    }
    
    func doHashTest(size: Int, initialArraySize: Int) -> [Double] {
        makeStringList(size: size)
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = HashMap<String, String>(initialArraySize: initialArraySize)
        
        for n in 0..<(size - 1) {                    //preset the map contents
            map.set(stringList[n], v: stringList[n])        //# of entries present stays constant through all operations
        }                                                   //leave 1 left though to use to for the set value
        
        let freshArrayHash = map.keys                           //use to refresh keys and values in map each operation
        let freshArrayLinear = map.linearMap.keys
        let addValue = stringList[size - 1]          //last value left to add to map
        let c = map.getNumberCollisions()    //save set collisions -- ! missing the last set, but close enough !
        
        for _ in 0..<TOTAL_OPERATIONS {
            map.keys = freshArrayHash; map.values = freshArrayHash  //run at start to leave map full at end of loop
            map.linearMap.keys = freshArrayLinear; map.linearMap.values = freshArrayLinear
            startTimer()
            map.set(addValue, v: addValue)
            endTimer()
            time += elapsedTimems()
        }
        
        let setTime = time / Double(TOTAL_OPERATIONS)
        map.resetCollisions()    //reset for get
        
        time = 0.0                                          //reset time
        for _ in 0..<TOTAL_OPERATIONS {
            index = getRandomInt(range: size)
            key = stringList[index]
            startTimer()
            value = map.get(key)!
            endTimer()
            time += elapsedTimems()
            if !(value == key) { print("bad hash map... uh oh"); return [0] }   //something went wrong with map
        }
        
		//since the next function needs to know the number of collisions but has no access to the map, it is being
		//returned as a third element and fourth of the set
		//returns set, get, percent collisions
        return [setTime, time / Double(TOTAL_OPERATIONS), Double(c), Double(map.getNumberCollisions())]
        //[set_time, get_time, set_collisions, get_collisions]
    }

	func hashTest() -> Bool {             //bool represents if map works
        print("Running hash tests:")
        
        for size in ARRAY_SIZES {
            print("Better Case:")
            var result = doHashTest(size: size, initialArraySize: size * 5) //lower % collition
            if result[0] == 0 {return false}
            
            benchmarkMessageMillis(operationName: "Hash Map Set (size of \(size), \(result[2]) collisions)", time: result[0])
            benchmarkMessageMillis(operationName: "Hash Map Get (size of \(size), \(result[3]) collisions)", time: result[1])
            hashMapSetResults[size] = result[0]
            hashMapGetResults[size] = result[1]
            
            print("Worse Case:")
            result = doHashTest(size: size, initialArraySize: size / 5) //higher % collition (collisions / size)
            if result[0] == 0 {return false}    //map failed
            
            benchmarkMessageMillis(operationName: "Hash Map Set (size of \(size), \(result[2]) collisions)", time: result[0])
            benchmarkMessageMillis(operationName: "Hash Map Get (size of \(size), \(result[3]) collisions)", time: result[1])
            hashMapSetResults[size] = result[0]
            hashMapGetResults[size] = result[1]
            print()
        }
        return true
    }
}
