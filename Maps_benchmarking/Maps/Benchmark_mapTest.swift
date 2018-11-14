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
        for size in array_sizes {
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
            print("\nRunning binary tests:")
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
        for size in array_sizes {
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
    
    // func hashTest(nOperations: Int, size: Int) -> Bool {
    //     makeStringList(size: nOperations)
    //     var key = ""
    //     var value = ""
    //     var index = 0
        
    //     let map = HashMap<String, String>(initialArraySize: size)
        
    //     startTimer()
    //     for n in 0..<nOperations {
    //         map.set(stringList[n], v: stringList[n])
    //     }
    //     endTimer()
    //     let p = ratioOf(Double(map.getNumberCollisions()), outOf: Double(nOperations))
    //     benchmarkMessageMillis(operationName: "Hash Map Set (\(nOperations) operations, \(map.getNumberCollisions()) collisions, \(p)% collision rate)", time: getCurrentMillis())
    //     hashMapSetResults[nOperations] = elapsedTimems() / Double(nOperations)
        
    //     startTimer()
    //     for _ in 0..<nOperations {
    //         index = getRandomInt(range: nOperations)
    //         key = stringList[index]
    //         value = map.get(key)!
    //         if !(value == key) { print("bad hash map... uh oh"); return false }
    //     }
    //     endTimer()
        
    //     benchmarkMessageMillis(operationName: "Hash Map Get (\(nOperations) operations, \(map.getNumberCollisions()) collisions, \(p)% collision rate)", time: elapsedTimems())
    //     hashMapGetResults[nOperations] = elapsedTimems() / Double(nOperations)
    //     return true
    // }
    func doHashTest(size: Int, initialArraySize: Int) -> [Double] {
        makeStringList(size: size)
        var key = ""
        var value = ""
        var index = 0
        var time = 0.0
        
        let map = HashMap<String, String>(initialArraySize: initialArraySize);
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
        
		let c = map.getNumberCollisions()	//save set collisions
		map.numberCollisions = 0;	//reset for get
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
		//since the next function needs to know the number of collisions but has no access to the map, it is being
		//returned as a third element and fourth of the set
		//returns set, get, percent collisions
        return [set, time / Double(TOTAL_OPERATIONS), Double(c), Double(map.getNumberCollisions())]
        //[set_time, get_time, set_collisions, get_collisions]
    }

	func hashTest() -> Bool {             //bool represents if map works
		var numSetCollisions = 0;
		var numGetCollisions = 0;
        
        for size in array_sizes {
            let result = doHashTest(size: size, initialArraySize: size * 3)
            if result[0] == 0 {return false}
			numSetCollisions = Int(result[2]);
			numGetCollisions = Int(result[3]);
            
            benchmarkMessageMillis(operationName: "Hash Map Set (size of \(size), \(numSetCollisions) collisions, rate of \(Double(numSetCollisions) / Double(TOTAL_OPERATIONS))% collisions)", time: result[0])
            benchmarkMessageMillis(operationName: "Hash Map Get (size of \(size), \(numGetCollisions) collisions, rate of \(Double(numGetCollisions) / Double(TOTAL_OPERATIONS))% collisions)", time: result[1])
            hashMapSetResults[size] = result[0]
            hashMapGetResults[size] = result[1]
            print()
        }
        
        return true
    }
}
